module MMD
    class Action
        include Param
        include RequiredParams
        attr_reader :name, :lifecycle, :deploy_path, :options, :block, :environment, :mode, :finished

        def initialize(name, parameters, options = {}, &block)
            @name = name
            @environment = :all
            @mode        = :all
            @options = options
            @block = block
            @parameters = parameters
            @log_file = @parameters[:log_file]
            @logger     = MMD::Logger.for_log_file( "MMD::Action::#{name.to_s.camelize}", @log_file )
            @deploy_path = @parameters[:deploy_path]
            @checkout_path = @parameters[:checkout_path]
            @finished = false

            begin
                require "mmd/actions/#{name}"
                extend eval( "MMD::Actions::#{name.to_s.camelize}" )
                # #eval( "extend MMD::Actions::#{name.to_s.camelize}" )

                # action for name does not exist
            rescue LoadError => load_error
                raise ActionError.new( "#{name} action does not exist: #{load_error.inspect}" )
            end

            if self.respond_to?('required_options')
              self.required_options(@options)
            end
        end

        def execute
            @logger.info( "Executing #{@name}")
            before_action if self.respond_to?('before_action', true)
            if @block
              self.instance_eval( &block )
            end
            action if self.respond_to?('action', true)
            after_action if self.respond_to?('after_action', true)
            @finished = true
        end

        def environment=( environment )
            if environment
                if environment.instance_of? Array
                    @environment = environment.map{ |environ| environ.to_sym }
                elsif environment.instance_of? String
                    @environment = environment.to_sym
                elsif environment.instance_of? Symbol
                    @environment = environment
                else
                    @logger.error( "Invalid environment, must be instance of Array of String or Symbol: #{environment}" )
                    raise ActionError.new( "Invalid environment, must be instance of Array of String or Symbol: #{environment}")
                end
            else
                @environment = :all
            end
        end

        def mode=( mode )
            if mode
                if mode.instance_of? Array
                    @mode = mode.map{ |environ| environ.to_sym }
                elsif mode.instance_of? String
                    @mode = mode.to_sym
                elsif mode.instance_of? Symbol
                    @mode = mode
                else
                    @logger.error( "Invalid mode, must be instance of Array of String, Symbol: #{mode}" )
                    raise ActionError.new( "Invalid mode, must be instance of Array of String, Symbol: #{mode}" )
                end
            else
                @mode = :all
            end
        end


        alias :deployment_mode  :mode
        alias :deployment_mode= :mode=
    end
end