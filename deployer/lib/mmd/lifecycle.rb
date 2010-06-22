require 'mmd/param'

module MMD
    class Lifecycle
        include Param

        CONFIG_BEFORE = :config_before
        CONFIG        = :config
        CONFIG_AFTER  = :config_after
        BUILD_BEFORE  = :build_before
        BUILD         = :build
        BUILD_AFTER   = :build_after
        TEST_BEFORE   = :test_before
        TEST          = :test
        TEST_AFTER    = :test_after
        DEPLOY_BEFORE = :deploy_before
        DEPLOY        = :deploy
        DEPLOY_AFTER  = :deploy_after
        UPDATE_BEFORE = :update_before
        UPDATE        = :update
        UPDATE_AFTER  = :update_after

        attr_reader :name, :actions, :options, :spec, :parameters, :logger, :deploy_path, :checkout_path

        def initialize(name, spec, options = {}, &block)
            @name = name
            @spec = spec
            @parameters    = @spec.parameters
            @logger = MMD::Logger.for_log_file( "MMD::Lifecycle", @parameters[:log_file] )
            @deploy_path   = @spec.deploy_path
            @checkout_path = @spec.checkout_path
            @actions = []
            @options = options

            if block
                self.instance_eval( &block )
            end
        end

        def action(name, options={}, &block)
            name = name.to_sym
            @actions << Action.new(name, {:lifecycle_name => @name}.merge(@parameters.to_hash), @options.merge( options ), &block)
        end

        def for_deployment_mode(mode, options={}, &block )
            mode = mode.to_sym
            lifecycle = Lifecycle.new(@name, @spec, options.merge( @options ) )
            lifecycle.instance_eval( &block )
            lifecycle.actions.each do |action|
                action.mode = mode
                @actions << action
            end
        end

        def for_environment(environment, options={}, &block )
            environment = environment.to_sym            
            lifecycle = Lifecycle.new(@name, @spec, options.merge( @options ) )
            lifecycle.instance_eval( &block )
            lifecycle.actions.each do |action|
                action.environment = environment
                @actions << action
            end            
        end       
    end
end