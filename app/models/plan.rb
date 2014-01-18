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
    unless @config 
      raw_config = client_connection.list( namespace, recursive: true )
      
      @config = raw_config.except! "id"
    end

    @config
  end

  def config=(_config)
    @config = _config
  end

  def client_connection(connection = nil)
    if connection
      @connection = Deployer::Etcd::Client.new( connection )
    else
      @connection ||= Deployer::Etcd::Client.connect
    end
  end

  protected

  # Callback
  def init_config
    client_connection.put "#{namespace}/id", self.id
  end

  # Callback
  def save_config(_config=nil, prefix=nil)
    # XXX: need to tombstone values to remove them

    _config ||= self.config
    _config.each do |key,val|
      if val.is_a? Hash
        save_config(val, "#{prefix}/#{key}")
      else
        client_connection.put( "#{namespace}/#{prefix}/#{key}", val.to_s)
      end
    end
  end
end
