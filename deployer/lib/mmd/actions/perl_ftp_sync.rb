require 'open3'

module MMD
    module Actions
        module PerlFtpSync
            attr_reader :perl_script, :perl_cmd

            def before_action
                @options =
                  { :checkout_path => @parameters[:checkout_path],
                    :ftp_username  => @parameters[:ftp_username],
                    :ftp_password  => @parameters[:ftp_password],
                    :ftp_host      => @parameters[:ftp_host],
                    :ftp_path      => @parameters[:ftp_path] }.merge( @options )

                required_params( @options,
                  [ :checkout_path, :ftp_username, :ftp_password, :ftp_host, :ftp_path ], false )
                set_instance_variables( @options )

                @perl_script = File.join( MMD::Option.scripts, 'ftpsync.pl')
                if not File.exists?( @perl_script )
                  raise ActionError.new( "ftpsync script not found: #{@perl_script}" )
                end

                @perl_cmd = "export HOME=#{@checkout_path};perl #{@perl_script} -l -p ftpuser=#{@ftp_username} ftppasswd=#{@ftp_password} #{@checkout_path} ftp://#{@ftp_host}/#{@ftp_path}"
            end

            def action()
                @logger.info( "PerlFtpSync begin sync")
                @logger.debug( "  executing #{@perl_script}" )
                output = []
                IO.popen( @perl_cmd ) do |pipe|
                  pipe.sync = true
                  while msg = pipe.gets
                      output << msg
                      @logger.info( "  #{msg.strip()}" )
                  end
                end
                if RAILS_ENV != 'test' and output.size == 0
                  raise ActionError.new( "Failed to run script: #{@perl_script}" )
                end
                @logger.info( "finshed PerlFtpSync")
            end
        end
    end
end
