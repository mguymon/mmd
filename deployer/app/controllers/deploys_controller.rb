include_class "powerplant.deploy.LiveWire"
require 'mmd'
require 'log4r'

class DeploysController < ApplicationController
    before_filter :login_required

    def create
        @environment = Environment.find( params[:environment_id], :include => [:environment_parameters] )

        deploy_path = MMD::Deployer.create_deploy_path( @environment )
        
        log_file = File.join( deploy_path, "deploy.#{DateTime.now.strftime('%Y%m%d%H%M%S')}.log" )
        
        @deploy = Deploy.new()
        @deploy.deployed_at = DateTime.now.strftime('%Y-%m-%d %H:%M:%S')
        @deploy.deployed_by = params[:deployed_by]
        @deploy.is_running = true
        @deploy.is_success = false
        @deploy.environment = @environment
        @deploy.log_file = log_file
        @deploy.path = deploy_path
        @deploy.save()

        # Build the hash of parameters that are for this environment
        parameters = @environment.parameters
        
        # Create a new Deployer instance, which will pull the source
        # using the SourceManager, read in the mmb.rb and feed it to
        # MMD::Spec along with the parameters to execute the deploy.
        deployer = MMD::Deployer.new
        deployer.setup( @deploy, parameters )
        
        # Start as separate thread
        engine = LiveWire.new( deployer )
        if MMD::Option.should_use_threads == "true"
          logger.info( "spawning deploy thread" )
          engine.start()
        else
          logger.debug( "running deploy" )
          engine.execute()
        end

        log_reader = ProgressiveFileReader.new( log_file )
        log = log_reader.read( 0 )       

        respond_to do |format|
          format.html
          format.xml  do
              render :xml => (@deploy.to_xml( :except => [:log_file] ) do |xml|
                  xml.log_start 0
                  xml.log_end log.size
                  xml.progressive_log log
              end)
          end
        end
    end

    def show
        @deploy = Deploy.find( params[:id] )

        start = 0
        if params[:start]
            start = params[:start].to_i
        end

        log_reader = ProgressiveFileReader.new( @deploy.log_file )
        log = log_reader.read( start )

        respond_to do |format|
          format.html
          format.xml  do
              render :xml => (@deploy.to_xml( :except => [:log_file] ) do |xml|
                  xml.log_start 0
                  xml.log_end start + log.size
                  xml.progressive_log log
              end)
          end
        end
    end
end
