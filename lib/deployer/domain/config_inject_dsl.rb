require 'deployer/etcd/client'

module Deployer
  class Domain::ConfigInjectDsl

    attr_reader :deploy

    def intialize(deploy)
      @deploy = deploy
      @config = {}

      @client = Deployer::Etcd::Client.connect
    end

    def set( name )
      @config[name.to_s] = @client.get "/app/#{@deploy.plan.namespace}/config/#{name}"
      
      self
    end

    def to_hash
      @config
    end

  end
end