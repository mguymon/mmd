module MMD
    module Actions
        module UpdateFile
            def self.extended( base )
                
            end

            def replace( file, match, replace, options={} )
                options = @options.merge( options )
                file = File.join( @checkout_path, file )
                if File.exists?( file)

                  if options[:destination]
                      destination = options[:destination]
                      destination = File.join( @checkout_path, destination )
                      FileUtils.move( file, destination )
                      file = destination
                  end
                  file_handle = File.new( file, "r")

                  file_contents = ""
                  file_handle.read( nil, file_contents )
                  file_handle.close()

                  file_contents = file_contents.gsub( match, replace )

                  File.open( file, 'w') {|f| f.write(file_contents) }
                else
                  raise ActionError.new( "update_file.replace - file does not exist: #{file}" )
                end
            end

            def expand_tokens( file, options={ :tokens => {} } )
                options = @options.merge( options )

                file = File.join( @checkout_path, file )
                if File.exists?( file)

                  if options[:destination]
                      destination = options[:destination]
                      destination = File.join( @checkout_path, destination )
                      FileUtils.move( file, destination )
                      file = destination
                  end

                  file_handler = File.new( file, "r")
                  file_contents = ""
                  file_handler.read( nil, file_contents )
                  file_handler.close()

                  options[:tokens].each do |key,val|
                      match = /%#{key.to_s.upcase}%/
                      replace = val.to_s
                      file_contents = file_contents.gsub( match, replace )
                  end

                  File.open( file, 'w') {|f| f.write( file_contents ) }
                else
                  raise ActionError.new( "update_file.expand_tokens - file does not exist: #{file}" )
                end
            end

            def move( file, destination, options = { :force => false } )
                file = File.join( @checkout_path, file )
                destination = File.join( @checkout_path, destination )

                if !File.exists?( file )
                  raise RuntimeError.new( "Attempting to move non-existant file: #{file}")
                end

                if File.exists?( destination )&& options[:force] != true
                  raise RuntimeError.new( "Attempting to overwrite file: #{destination}")
                end
                
                FileUtils.move( file, destination )
            end
        end
    end
end
