require 'net/ssh'
require 'net/scp'

module MMD
  module Actions
    module Remote
      attr_accessor :host, :user, :password

      def before_action
        @cmds = []
      end

      def action( options = {} )
        if @cmds.size > 0
          Net::SSH.start( @host, @user, :password => @password ) do |ssh|
            @logger.info "Host: #{ssh.exec!("hostname")}"

            @cmds.each do |cmd|
              if cmd.is_a? Upload
                Net::SCP.upload!( @host, @username, cmd.upload_file, cmd.upload_to,
                  :password => @passowrd )

              elsif cmd.is_a? Download
                Net::SCP.download!( @host, @username, cmd.remote_file, cmd.local_file,
                  :password => @password)

              elsif cmd.is_a? Exec
                channel = ssh.open_channel do |ch|

                  if cmd.is_sudo
                    channel.request_pty do |ch, success|
                      raise "Could not obtain pty" if !success
                    end
                  end

                  @logger.info "Exec #{cmd.cmd}"
                  ch.exec cmd.cmd do |ch, success|
                    raise "could not execute command: #{cmd.cmd}" unless success

                    # "on_data" is called when the process writes something to stdout
                    ch.on_data do |c, data|

                      # pass in password for sudo request
                      if cmd.is_sudo && cmd.password_sent != true && data =~ /password:/i
                        ch.send_data "#{@password}\n"
                        cmd.password_sent = true
                      else
                        @logger.info data
                      end

                    end

                    # "on_extended_data" is called when the process writes something to stderr
                    ch.on_extended_data do |c, type, data|
                      @logger.error data
                    end

                    ch.on_close { @logger.info "Finished #{cmd.cmd}" }
                  end
                end

                channel.wait
              end
            end
          end
        end
      end

      def exec( cmd )
        @cmds << Exec.new( cmd )
      end

      def sudo_exec( cmd )
        @cmds << Exec.new( "sudo #{cmd}", :sudo => true )
      end

      def upload( file, upload_to )
        upload_file = File.join( @checkout_path, file )
        @cmds << Upload.new( upload_file, upload_to)
      end

      def download( remote_file, file )
        local_file = File.join( @checkout_path, file )
        @cmds << Download.new( remote_file, local_file )
      end

      class Upload
        attr_reader :file, :upload_to
        def initialize( file, upload_to )
          @file = file
          @upload_to = upload_to
        end
      end

      class Download
        attr_reader :remote_file, :file
        def initialize( remote_file, file )
          @remote_file = remote_file
          @file = file
        end
      end

      class Exec
        attr_reader :cmd, :is_sudo
        attr_accessor :password_sent
        def initialize( cmd, options = {} )
          @cmd =cmd

          if options[:sudo] == true
            @is_sudo = true
          else
            @is_sudo = false
          end
        end
      end
    end
  end
end
