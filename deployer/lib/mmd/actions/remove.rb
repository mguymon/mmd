require 'fileutils'

module MMD
    module Actions
        module Remove
            def self.extended( base )
                
            end

            def file( path_or_array )
                if path_or_array.class == Array
                    path_or_array.each do |path|
                        file( path )
                    end
                else
                    path = path_or_array
                    path = File.join( @checkout_path, path )
                    if File.exists? path
                        File.delete( path )
                    else
                        Dir.glob( path ) do |location|
                            if File.file? location
                                File.delete( location )
                            end
                        end
                    end
                end
            end

            def dir( path_or_array, options = { :empty_dir_only => true } )
                options = options.merge( @options )

                if path_or_array.class == Array
                    path_or_array.each do |path|
                        dir( path, options )
                    end
                else
                    path = path_or_array
                    path = File.join( @checkout_path, path )
                    Dir.glob( path ) do |location|
                        if File.directory? location
                            files = Dir.entries( location )
                            if files.size > 2
                                if not options[:empty_dir_only]                                    
                                    FileUtils.rm_r( location )
                                else
                                    raise ActionError.new( "Attempting to remove a directory that is not empty" )
                                end
                            else
                                Dir.rmdir( location )
                            end
                        end
                    end
                end
            end
        end
    end
end