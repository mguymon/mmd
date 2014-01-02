module Deployer
  class Domain::ServerDsl

    attr_reader :deploy

    def intialize(deploy)
      @deploy = deploy


      @client = Etcd::Client.connect(uris: 'http://localhost:4001')
      @client.connect

      @region   = @client.get( "/app/#{@plan.namespace}/devopts/region" )
      @ami      = @client.get( "/app/#{@plan.namespace}/devopts/ami" )
      @key_name = @client.get( "/app/#{@plan.namespace}/devopts/key_name" )
      @availability_zone = @client.get( "/app/#{@plan.namespace}/devopts/availability_zone" )
      @instance_type     = @client.get( "/app/#{@plan.namespace}/devopts/instance_type" )

      @connection = Fog::Compute.new({
           :provider                 => 'AWS',
           :aws_access_key_id        => ENV['AWS_ACCESS_KEY_ID'],
           :aws_secret_access_key    => ENV['AWS_SECRET_ACCESS_KEY']
       })
    end


    def create(id, opts = {})
      options = opts.merge( 'wait_for_ready' => true )
      image = @connection.images.all('image-id' =>@ami).first

      server = @connection.servers.create(
          :tags => {'namespace' => @plan.namespace, 'deploy_id' => id},
          :flavor_id => @instance_type,
          :image_id => image.id,
          :key_name => @key_name,
          :availability_zone => @availability_zone
      )

      @deploy.devopts.servers[id] = Deployer::Domain::Server.new( @deploy, server )

      if options['wait_for_ready']
        server.wait_for { ready? }
      end

      self
    end

  end
end