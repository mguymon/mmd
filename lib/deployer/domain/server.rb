module Deployer

  class Domain::Server

    def initialize(deploy, server)
      @deploy = deploy
      @server = server
    end

    def task(&blk)
      dsl = ServerTaskDsl.new(@deploy)
      dsl.instance_eval(&blk) if blk
      @config.merge( dsl.to_hash )

      dsl
    end

    def wait_for_ready
      @server.wait_for { ready? }
      self
    end
  end
end