include_class "powerplant.deploy.AbstractDeployment"
require 'mmd'
module MMD
  class Deployer < AbstractDeployment

    # All ActiveRecord operation must be made here. Once Deployer runs in its
    # own thread, it will not be able to access ActiveRecord calls
    def setup( deploy, parameters )
      @log_file = deploy.log_file
      @logger = MMD::Logger.for_log_file( 'MMD::Deployer', @log_file )
      @environment_id = deploy.environment.id
      @deploy    = deploy
      @deploy_id = deploy.id
      @deploy_path = deploy.path
      @name        = deploy.environment.name
      @mode        = deploy.environment.deployment_mode      
      @deploy_dao = getBean( 'deployDAO' );

      parameters[:name]        = @name
      parameters[:mode]        = @mode
      parameters[:log_file]    = @log_file
      parameters[:deploy_path] = @deploy_path
      @parameters = parameters
    end

    def getLogFile
      @log_file
    end

    def onError( exception )
      super
      @logger.error( "Error: #{exception.toString()}" )
      if @deploy_process != nil
        begin
          @deploy_dao.deleteDeployProcessByDeployId( @deploy_id )
          @deploy_dao.updateCompletedDeploy( @deploy_id, false, "Error on deploy: #{exception.inspect}" )
          @logger.debug( "Deleted DeployProcess for environment id: #{@environment_id}")
        rescue
          @logger.error( "Failed remove old DeployProcess for environment id #{@environment_id}, will block this environment until removed: #{$!}")
        end
      end
    end

    def beforeStart()
      super

      @logger.debug( "Begin deploy" )

      if @deploy_id
        begin
          @deploy_process = @deploy_dao.createDeployProcess( @environment_id, @deploy_id )
          @logger.debug( "Created DeployProcess: #{@deploy_process.getId()}")
        rescue
          @logger.error( "Duplicate deploy for: #{@name}" )
          @deploy_dao.updateCompletedDeploy( @deploy_id, false, "Deploy already running for environment #{@name}" )
          raise
        end
      else
        @logger.error( "Deploy id is nil" )
        raise "Deploy id is nil"
      end
    end

    def execute()
      super

      # Set parameters in ThreadLocal variable
      Deployer::Config.set( @parameters )

      source_manager = MMD::SourceManager.new(
            Deployer::Config[:scm], Deployer::Config )

      Deployer::Config[:scm_repository] = source_manager.repository
      
      @logger.info(  "Checking out source from #{source_manager.name}" )
      begin
        source_manager.checkout
        @logger.info(  "Finished Checking out source from #{source_manager.name}" )
      rescue
        @logger.error( "Failed to deploy, source checkout failed: #{$!.inspect}" )
        @deploy_dao.updateCompletedDeploy( @deploy_id, false, "Failed to deploy: #{$!.inspect}" )
        raise
      end

      Deployer::Config[:checkout_path] = source_manager.checkout_path
      
      begin
        mmd_config_file = File.join( @deploy_path, "checkout", "mmd.rb" )
        if File.exist? mmd_config_file
          @logger.debug(  "Reading mmd.rb" )
          mmd_config = read_mmd_file( mmd_config_file )                    
          spec = MMD::Spec.new(
            @name, @mode, Deployer::Config )
          @logger.info(  "Executing mmd.rb" )
          spec.execute( mmd_config )
          @deploy_dao.updateCompletedDeploy( @deploy_id, true, "Successfully completed deploy" )
        else
          @logger.error( "mmd.rb does not exist" )
          raise DeployError.new( "mmd.rb does not exist" )
        end
      rescue
        @logger.error( "Failed to read #{mmd_config_file} and deploy: #{$!.inspect}" )
        @logger.error( $! )
        @deploy_dao.updateCompletedDeploy( @deploy_id, false, "Failed to deploy: #{$!.inspect}" )
        raise
      end

    end

    def afterFinish()
      super
      if @deploy_process != nil
        @deploy_dao.deleteDeployProcessByDeployId( @deploy_id )
        @logger.debug( "Deleted DeployProcess for environment id: #{@environment_id}")
      end
    end

    def self.create_deploy_path( environment, create = true )
        
        mmd_workspace_dir = MMD::Option.workspace
        if not File.exists?( mmd_workspace_dir ) and create
            Dir.mkdir( mmd_workspace_dir )
        end

        app = environment.app
        project = app.project
        client = project.client

        client_dir = File.join( mmd_workspace_dir, client.short_name )
        if not File.exists?( client_dir ) and create
            Dir.mkdir( client_dir )
        end

        project_dir = File.join( client_dir, project.short_name )
        if not File.exists?( project_dir ) and create
            Dir.mkdir( project_dir )
        end

        app_dir = File.join( project_dir, app.short_name )
        if not File.exists?( app_dir ) and create
            Dir.mkdir( app_dir )
        end

        deploy_dir = File.join( app_dir, environment.name )
        deploy_path = File.expand_path( deploy_dir )
        if not File.exists?( deploy_path ) and create
            Dir.mkdir( deploy_path )
        end

        deploy_path
    end  

    private

    def read_mmd_file( path )
      mmd_config_handle = File.new( path, "r")
      mmd_config = ""
      mmd_config_handle.read( nil, mmd_config )
      mmd_config_handle.close()

      mmd_config
    end
  end

  class DeployError < RuntimeError

  end

end
