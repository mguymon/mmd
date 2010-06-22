require 'mmd'
Dir.glob( "#{RAILS_ROOT}/lib/mmd/source_managers/*.rb" ).each do |path|
  require "mmd/source_managers/#{File.basename(path)}"
end

module MMD
    class SourceManager
        include MMD::RequiredParams
        
        CHECKOUT_DIR = 'checkout'
        
        attr_reader :name, :parameters, :checkout_path

        def initialize( name, parameters = {} )
            required_params( parameters, [ :deploy_path, :log_file ] )

            @name = name
            @checkout_path = File.join( parameters[:deploy_path], CHECKOUT_DIR )
            @logger = MMD::Logger.for_log_file( 'MMD::SourceManager', parameters[:log_file] )
            @parameters = parameters.merge( :checkout_path => @checkout_path, :logger => @logger )
            @manager = nil
            begin
              @manager = eval("MMD::SourceManagers::#{@name.to_s.camelize}").new( @parameters )
                
            # action for name does not exist
            rescue LoadError => load_error
                raise ActionError.new( "MMD::SourceManager - #{@name} source management does not exist", load_error )
            end
        end

        def checkout
          @manager.checkout
        end

        def repository
          @manager.repository
        end
    end
end