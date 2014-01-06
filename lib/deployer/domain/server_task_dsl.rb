module Deployer
  class Domain::ServerTask
    attr_reader :deploy

    def intialize(deploy, server)
      @deploy = deploy
      @server = server
    end

    def run(*commands)
      commands.each do |command|
        @server.ssh(command)
      end
    end

    #def update_file(file, token, replacement)
    #
    #end

    def fetch

    end
  end
end