module MMD
    module Param
        def param( key_or_hash=nil )
            if key_or_hash
                the_class = key_or_hash.class
                if the_class == String or the_class == Symbol
                    return @parameters[key_or_hash]                
                elsif the_class == Hash
                    @parameters.set( @parameters.merge( key_or_hash ) )
                    return @parameters
                end
            else
                return @parameters
            end
        end

        alias :params :param
    end
end
