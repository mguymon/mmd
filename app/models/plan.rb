require 'deployer/etcd/client'

class Plan < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => :scoped, :scope => [:account_id]

  has_settings do |s|
    s.key :config
  end

  belongs_to :account
  has_many :services
  has_many :user_plans
  has_many :users, through: :user_plans

  after_create :init_config
  after_save :save_config

  def namespace
    "/plans/#{self.account.id}/#{self.name}"
  end

  def config
    @config ||= config_client.list( namespace, recursive: true ).except! "id"
  end

  def config=(_config)
    @config = _config
  end

  def config_client
    # XXX: this needs to be crammed into the test area
    if Rails.env.test?
      connection = Faraday.new do |builder|
        builder.adapter :test do |stub|
          json = '{"action"=>"set", "node"=>{"key"=>"/test", "modifiedIndex"=>26, "createdIndex"=>26}}'
          stub.put("/v2/keys/#{self.namespace}/id") {[ 200, {:value=>self.id}, json]}
        
          json = '{"action":"get","node":{"key":"/","dir":true,"nodes":[{"key":"/foo","value":"bar","modifiedIndex":3,"createdIndex":3},{"key":"/w00t","value":"rawr","modifiedIndex":4,"createdIndex":4}]}}'
          stub.get("/v2/keys/#{namespace}") {[ 200, {}, json ]}
        end
      end
      Deployer::Etcd::Client.new( connection )
    else
      @connection ||= Deployer::Etcd::Client.connect
    end
  end

  protected

  # Callback
  def init_config
    config_client.put "#{namespace}/id", self.id
  end

  # Callback
  def save_config(_config=nil, prefix=nil)
    # XXX: need to tombstone values to remove them

    _config ||= self.config
    _config.each do |key,val|
      if val.is_a? Hash
        save_config(val, "#{prefix}/#{key}")
      else
        config_client.put( "#{prefix}#{namespace}/#{key}", val.to_s)
      end
    end
  end
end
