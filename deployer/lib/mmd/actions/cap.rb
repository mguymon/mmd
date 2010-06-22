require 'rubygems'
require 'capistrano/configuration'
require 'capistrano/cli'

module MMD
  module Actions
    module Cap
      attr_reader :environment      

      def task(task)
        @mmdistrano.add_action( task )
      end

      private
      def before_action
        
        @environment  = @parameters[:cap_environment] ? @parameters[:cap_environment] : @parameters[:mode]

        @override_vars = get_options_from_global_parameters(
          [ [:cap_username, :username], [:cap_password, :password], [:scm_repository, :repository], :scm, :scm_username, :scm_password,
            :production_database, :production_dbhost, :dbuser, :dbpass ], @parameters )

        if @options[:deploy_file]
          @deploy_file = File.join( @parameters[:checkout_path], @options[:deploy_file] )
        else
          @deploy_file = File.join( @parameters[:checkout_path], 'config/deploy.rb' )
        end

        @mmdistrano = MMDisatranoCLI.new( @parameters[:checkout_path], @logger, [@deploy_file], [@environment], [], @override_vars )
      end

      def action()
        @mmdistrano.execute!
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

    class MMDisatranoCLI
      include Capistrano::CLI::Execute, Capistrano::CLI::Options

      def initialize( checkout_path, logger, recipes, base_actions, vars, pre_vars, verbose = 3 )
        @checkout_path = checkout_path
        @logger = logger
        @options = {
	        :recipes => recipes,
	        :actions => base_actions,
	        :vars => vars,
	        :pre_vars => pre_vars,
	        :verbose => verbose
	      }
      end

      def add_action( action )
        @options[:actions] << action
      end

      def execute!
        config = instantiate_configuration
        set_pre_vars(config)
        config.override_enabled = true

        config.load "standard"

        # load systemwide config/recipe definition
        config.load(options[:sysconf]) if options[:sysconf] && File.file?(options[:sysconf])

        # load user config/recipe definition
        config.load(options[:dotfile]) if options[:dotfile] && File.file?(options[:dotfile])

        config.load 'deploy' if config.respond_to?(:namespace) # cap2 differentiator
        Dir["#{@checkout_path}/vendor/plugins/*/recipes/*.rb"].each { |plugin|
          config.load(plugin)
        }
        Array(options[:recipes]).each { |recipe| config.load(recipe) }

        config.trigger(:load)
        execute_requested_actions(config)
        config.trigger(:exit)
        config.override_enabled = false
      end

      def instantiate_configuration
        config = MMDisatranoConfiguration.new
        config.instance_variable_set( :@logger, Logger.new(@logger) )
        config.override_vars = @options[:pre_vars]

        config
      end
    end

    # Extends Capistrano::Configuration to overrides the set method to provide
    # a lockdown for MMD deploy parameters
    class MMDisatranoConfiguration < Capistrano::Configuration
      attr_accessor :override_vars
      attr_accessor :override_enabled     
     
      # Set a variable to the given value.
      def set(variable, *args, &block)
        if variable.to_s !~ /^[_a-z]/
          raise ArgumentError, "invalid variable `#{variable}' (variables must begin with an underscore, or a lower-case letter)"
        end

        if !block_given? && args.empty? || block_given? && !args.empty?
          raise ArgumentError, "you must specify exactly one of either a value or a block"
        end

        if args.length > 1
          raise ArgumentError, "wrong number of arguments (#{args.length} for 1)"
        end
        
        if @override_enabled && @override_vars.include?( variable )
          logger.info "#{variable} cannot be overridden"          
        else
          value = args.empty? ? block : args.first
          sym = variable.to_sym
          protect(sym) { @variables[sym] = value }
        end
      end
    end

    class Logger
      attr_accessor :level
      attr_reader   :device

      IMPORTANT = :info
      INFO      = :info
      DEBUG     = :debug
      TRACE     = :error

      def initialize(logger)
        @logger = logger
      end

      def close
        true
      end

      def log(level, message, line_prefix=nil)
              
          (RUBY_VERSION >= "1.9" ? message.lines : message).each do |line|
            if line_prefix
              @logger.send( level, "[#{line_prefix}] #{line.strip}")
            else
              @logger.send( level, "#{line.strip}")
            end
          end
        
      end

      def important(message, line_prefix=nil)
        log(IMPORTANT, message, line_prefix)
      end

      def info(message, line_prefix=nil)
        log(INFO, message, line_prefix)
      end

      def debug(message, line_prefix=nil)
        log(DEBUG, message, line_prefix)
      end

      def trace(message, line_prefix=nil)
        log(TRACE, message, line_prefix)
      end
    end
  end
end
