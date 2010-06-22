module MMD
    class Deployer
      # Wrapper for Threadlocal variable in Deployer
      class Config

        def self.get(key=nil)
          if key
            Config[key]
          else
            Deployer::getConfiguration()
          end
        end

        def self.to_hash
          Deployer::getConfiguration()
        end

        def self.set( config_or_key, val = nil )
          if config_or_key.class == Hash
            sym_vals = {}
            config_or_key.each do |k,v|
              sym_vals[k.to_sym] = v
            end
            Deployer::setConfiguration( sym_vals )
          else
            DeployConfig[config_or_key] = val
          end
        end

        def self.[](key)
          config = Deployer::getConfiguration()
          config[key.to_sym] if config
        end

        def self.[]=(key,val)
          config = Deployer::getConfiguration()
          config[key.to_sym] = val
          Deployer::setConfiguration(config)
        end

        def self.keys
          Deployer::getConfiguration().keys
        end

        def self.has_key?( key )
          Deployer::getConfiguration.has_key?( key.to_sym )
        end

        def self.include?( key)
          Config.has_key?( key )
        end

        def self.key?( key)
          Config.has_key?( key )
        end

        def self.memeber?( key)
          Config.has_key?( key )
        end

        def self.merge( hash )
          Deployer::getConfiguration().merge( hash )
        end

      end
    end
end
