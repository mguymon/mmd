require 'rubygems'
require 'capistrano/configuration'
require 'capistrano/cli'
require 'mmd/capistrano'

module MMD
  module Actions
    module Cap
      attr_reader :environment
      attr_reader :tasks

      def task(task)
        #@mmdistrano.add_action( task )
        @tasks << task
      end

      private
      def before_action
        @tasks = []
        
        @environment  = @parameters[:cap_environment] ? @parameters[:cap_environment] : @parameters[:mode]

        @override_vars = get_options_from_global_parameters(
          [ [:cap_username, :username], [:cap_password, :password], [:scm_repository, :repository], :scm, :scm_username, :scm_password,
            :production_database, :production_dbhost, :dbuser, :dbpass, :stage_dir ], @parameters )

        
        if @options[:deploy_file]
          @deploy_files = ["#{@parameters[:checkout_path]}/#{@options[:deploy_file]}"]
        else
          @deploy_files = ["#{@parameters[:checkout_path]}/config/deploy.rb"]
        end

        #@mmdistrano = MMDisatranoCLI.new( @parameters[:checkout_path], @logger, @deploy_files, [@environment], [], @override_vars )
      end

      def action()
        mmdistrano = MMDisatranoCLI.new( @parameters[:checkout_path], @logger, @deploy_files, [], [], @override_vars )
        mmdistrano.add_actions( @tasks )
        mmdistrano.execute!
      end     

      # Get options from global parameters, if they exist
      def get_options_from_global_parameters( vars, global )
        options = {}
        vars.each do |var|
          if var.class == Array
            if global.include?( var[0] )
              options[var[1]] = global[var[0]]
            end
          else
            if global.include?( var )
              options[var] = global[var]
            end
          end
        end

        options
      end
    end

    
  end
end
