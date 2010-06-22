require 'mmd/lifecycle'

module MMD
  class Spec
    attr_reader :lifecycles, :environment, :environment_name, :deployment_mode,
      :application, :parameters, :deploy, :workspace_dir, :mmd_path,
      :deploy_path, :logger, :checkout_path
    LIFECYCLE_STAGES = [
      Lifecycle::CONFIG_BEFORE,
      Lifecycle::CONFIG,
      Lifecycle::CONFIG_AFTER,
      Lifecycle::BUILD_BEFORE,
      Lifecycle::BUILD,
      Lifecycle::BUILD_AFTER,
      Lifecycle::TEST_BEFORE,
      Lifecycle::TEST,
      Lifecycle::TEST_AFTER,
      Lifecycle::DEPLOY_BEFORE,
      Lifecycle::DEPLOY,
      Lifecycle::DEPLOY_AFTER,
      Lifecycle::UPDATE_BEFORE,
      Lifecycle::UPDATE,
      Lifecycle::UPDATE_AFTER ]

    def initialize( name, mode, parameters )
            
      @logger = MMD::Logger.for_log_file( "MMD::Spec", parameters[:log_file] )
      @deploy_path = parameters[:deploy_path]
      @checkout_path = parameters[:checkout_path]
      @environment_name = name.downcase.to_sym
      @deployment_mode  = mode.downcase.to_sym     

      @parameters = parameters

      @mmd_path        = File.dirname( File.dirname( File.expand_path( File.dirname(__FILE__) ) ) )
      @parameters[:mmd_path] = @mmd_path
    end

    def lifecycle(stage, &block)
      stage = "#{stage}".downcase.to_sym
      if LIFECYCLE_STAGES.include? stage
        @lifecycles[stage] = Lifecycle.new(stage, self, &block )
      else
        raise SpecError.new( "Invalid lifecycle [#{stage}] in configuration" )
      end
    end

    def execute( config )
      @logger.info( "Executing Lifecycles" )
      @lifecycles   = {}
      self.instance_eval( config )
            
      LIFECYCLE_STAGES.each do |stage|
        if @lifecycles[stage]
          @logger.info( "--= Lifecycles #{stage} =--" )
          @lifecycles[stage].actions.each do |action|
            action_environment = convert_to_sym( action.environment )
            if action_environment == :all or eql_or_included?( @environment_name, action_environment )
              action_mode = convert_to_sym( action.mode )
              if action_mode == :all or eql_or_included?( @deployment_mode, action_mode )
                action.execute
              else
                @logger.debug( "Action skipped due to deployment_mode [#{@deployment_mode}] for Action [#{action_mode}]" )
              end
            else
              @logger.debug( "Action skipped due to environment [#{@environment_name}] for Action [#{action_environment}]" )
            end
          end
          close_log = ""
          (20 + stage.to_s.size ).times { close_log << "-" }
          @logger.info( close_log )
        end
      end
    end

    def convert_to_sym( might_be_an_array )
      if might_be_an_array.is_a? Array
        return might_be_an_array.map{ |val| "#{val}".downcase.to_sym }
      elsif might_be_an_array.is_a? Symbol
        return might_be_an_array
      else
        return "#{might_be_an_array}".downcase.to_sym
      end
    end

    def eql_or_included?( sym, might_be_an_array )
      if sym == might_be_an_array
        return true
      elsif might_be_an_array.is_a? Array
        if might_be_an_array.include? sym
          return true
        end
      end

      false
    end
  end

  class SpecError < RuntimeError

  end

end