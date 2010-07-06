require 'net/ssh'
require 'net/scp'

module MMD
  module Actions
    module Remote
      attr_accessor :host, :username, :timestamp


      def exec( cmd, options = {}, &block )
        exec = Exec.new( cmd, options )
        if block
          exec.instance_eval( &block )
        end

        @cmds << exec
      end

      def sudo_exec( cmd, options = {}, &block )
        exec = Exec.new( "sudo #{cmd}", options)
        exec.is_sudo = true
        if block
          exec.instance_eval( &block )
        end

        @cmds << exec
      end

      def upload_file( file, upload_to )
        upload_file = File.join( @checkout_path, file )
        @cmds << Upload.new( upload_file, upload_to)
      end

      def download_file( remote_file, file )
        local_file = File.join( @checkout_path, file )
        @cmds << Download.new( remote_file, local_file )
      end

      private 
      def before_action
        @cmds = []

        @options =
          { :host => @parameters[:remote_host],
          :username  => @parameters[:remote_username],
          :password  => @parameters[:remote_password],
          :timestamp => @parameters[:timestamp] }
          
        set_instance_variables( @options )
      end

      def action( options = {} )
        if @cmds.size > 0
          Net::SSH.start( @host, @username, :password => @password ) do |ssh|
            @logger.info "Host: #{ssh.exec!("hostname")}"
            
            @cmds.each_index do |index|
              cmd = @cmds[index]
              if cmd.is_a? Upload
                @logger.info "Uploading #{cmd.file} to #{cmd.upload_to}"
                Net::SCP.upload!( @host, @username, cmd.file, cmd.upload_to,
                  :password => @passowrd )

              elsif cmd.is_a? Download
                @logger.info "Downloading #{cmd.remote_file} to #{cmd.local_file}"
                Net::SCP.download!( @host, @username, cmd.remote_file, cmd.local_file,
                  :password => @password)

              elsif cmd.is_a? Exec
                
                @logger.info "Exec #{cmd.cmd}"
                
                if cmd.is_sudo
                  channel = ssh.open_channel do |ch|
                    channel.request_pty do |ch, success|
                      raise "Could not obtain pty" if !success
                    end

                    ch.exec cmd.cmd do |ch, success|
                      raise "could not execute command: #{cmd.cmd}" unless success

                      output = ""
                      # "on_data" is called when the process writes something to stdout
                      ch.on_data do |c, data|

                        # pass in password for sudo request
                        if cmd.is_sudo && cmd.password_sent != true && data =~ /password:/i
                          ch.send_data "#{@password}\n"
                          cmd.password_sent = true
                        else
                          output << data
                          @logger.info data
                        end

                      end

                      # "on_extended_data" is called when the process writes something to stderr
                      ch.on_extended_data do |c, type, data|
                        output << data
                        @logger.error data
                      end

                      ch.on_close do
                        @logger.info "Finished #{cmd.cmd}"

                        if cmd.continue && cmd.until_output_check( output )
                          if (index + 1) == @cmds.size
                            @cmds << cmd
                          else
                            @cmds.insert(index+1, cmd)
                          end

                          sleep cmd.pause
                        end

                      end
                    end
                  end
                  channel.wait
                else
                  ssh.exec cmd.cmd do |ch, success|
                    raise "could not execute command: #{cmd.cmd}" unless success

                    output = ""
                    # "on_data" is called when the process writes something to stdout
                    ch.on_data do |c, data|
                      output << data
                      @logger.info data
                    end

                    # "on_extended_data" is called when the process writes something to stderr
                    ch.on_extended_data do |c, type, data|
                      output << data
                      @logger.error data
                    end

                    ch.on_close do
                      @logger.info "Finished #{cmd.cmd}"

                      if cmd.continue && cmd.until_output_check( output )
                        if (index + 1) == @cmds.size
                          @cmds << cmd
                        else
                          @cmds.insert(index+1, cmd)
                        end

                        sleep cmd.pause
                      end

                    end
                  end

                  ssh.loop

                end

              end
            end
          end
        end
      end
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
      attr_reader :cmd, :pause, :max, :continue, :until_output_expects
      attr_accessor :password_sent, :is_sudo
      def initialize( cmd, options = {} )
        options = HashWithIndifferentAccess.new(
          :pause => 3,
          :max => 10 ).merge( options )
          
        @cmd = cmd
        @is_sudo = false
        @pause = options[:pause]
        @max = options[:max]

      end

      def until_output( expects )
        @continue = true
        @until_output_expects = expects
        @attempt = 0
      end

      def until_output_check( output )
        if @attempt < @max
          @attempt = @attempt + 1
          @continue = (output =~ /#{@until_output_expects}/).nil?
        else
          raise ExecMaxAttemptsError.new( "Reach max attempts: #{@max} to match: #{@until_output_expects}" )
        end
      end
    end

    class ExecMaxAttemptsError < RuntimeError
        
    end
  end
end
