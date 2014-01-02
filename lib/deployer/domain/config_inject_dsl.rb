module Deployer
  class Domain::ConfigInjectDsl

    attr_reader :deploy

    def intialize(deploy)
      @deploy = deploy
      @config = {}

      ssl_opts = {
          client_cert: ENV['MMD_CLIENT_CERT'],
          client_key: ENV['MMD_CLIENT_KEY'],
          ca_file: ENV['MMD_CA_CERT']
      }

      @connection = Faraday.new(:url => "https://#{deploy.config.etc_addr}", ssl: ssl_opts) do |faraday|
        faraday.adapter Faraday::Adapter::Typhoeus
      end
    end

    def set( name )
      response = @connection.get "/app/#{@plan.namespace}/config/#{name}"
      result = JSON.parse(response.body)
      if result['node'] && result['node']['value']
        @config[name.to_s] = result['node']['value']
      end

      self
    end

    def to_hash
      @config
    end

  end
end