require 'rubygems'
require 'capistrano/configuration'
require 'capistrano/cli'

module MMD
 
  class MMDisatranoCLI
      include Capistrano::CLI::Execute, Capistrano::CLI::Options

      attr_accessor :capistrano_config

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

        @capistrano_config = instantiate_configuration(@checkout_path)
      end

      def add_action( action )
        @options[:actions] << action
      end

      def add_actions( actions )
        @options[:actions] = @options[:actions] + actions
      end

      def execute!
        config = instantiate_configuration(@checkout_path)

        @capistrano_config = config

        set_pre_vars(config)
        config.override_enabled = true

        config.load "standard"

        # load systemwide config/recipe definition
        config.load(options[:sysconf] ) if options[:sysconf] && File.file?(options[:sysconf])

        # load user config/recipe definition
        config.load(options[:dotfile] ) if options[:dotfile] && File.file?(options[:dotfile])

        config.load "deploy" if config.respond_to?(:namespace) # cap2 differentiator
        Dir["#{@checkout_path}/vendor/plugins/*/recipes/*.rb"].each { |plugin|
          config.load(plugin)
        }
        Array(options[:recipes]).each { |recipe| config.load(recipe) }

        config.trigger(:load)
        execute_requested_actions(config)
        config.trigger(:exit)
        config.override_enabled = false
        
      end

      def instantiate_configuration(checkout_path, options={})
        config = MMDisatranoConfiguration.new(options)
        config.logger.level = Capistrano::Logger::DEBUG
        config.checkout_path = checkout_path
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
      attr_accessor :checkout_path
      attr_accessor :loaded_features

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

      def load(*args, &block)
        options = args.last.is_a?(Hash) ? args.pop : {}

        if block
          raise ArgumentError, "loading a block requires 0 arguments" unless options.empty? && args.empty?
          load(:proc => block)

        elsif args.any?
          args.each { |arg| load options.merge(:file => arg) }

        elsif options[:file]
          file = options[:file]

          # If a relative file load was set to an absolute path to the checkout
          # check to see if the .rb needs to be appended.
          file += ".rb" if file =~ /^#{@checkout_path}/ && (file =~ /[.]rb$/).nil?
          
          logger.info "loading: #{file}"
          load_from_file(file, options[:name])

        elsif options[:string]
          #remember_load(options) unless options[:reloading]
          instance_eval(options[:string], options[:name] || "<eval>")

        elsif options[:proc]
          #remember_load(options) unless options[:reloading]
          instance_eval(&options[:proc])

        else
          raise ArgumentError, "don't know how to load #{options.inspect}"
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