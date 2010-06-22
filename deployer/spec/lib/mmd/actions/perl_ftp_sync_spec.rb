require 'spec/spec_helper.rb'
require 'mmd'

describe MMD::Action do
  before(:each) do        
        @checkout_path  = "deploy"
        @ftp_host     = "ftp_host"
        @ftp_username = "ftp_username"
        @ftp_password = "ftp_password"
        @ftp_path     = "ftp_path"

        @spec = create_spec(
            :mmd_path     => @mmd_path,
            :checkout_path  => @checkout_path,
            :ftp_host     => @ftp_host,
            :ftp_username => @ftp_username,
            :ftp_password => @ftp_password,
            :ftp_path     => @ftp_path )
        @lifecycle = MMD::Lifecycle.new( 'test', @spec )
        @checkout_path = @spec.parameters[ :checkout_path ]
    end

  it "should have a valid perl ftpsync command" do        
        @action = MMD::Action.new( :perl_ftp_sync, @lifecycle.parameters )
        @action.before_action
        @action.perl_script.should eql( File.join(@spec.parameters[ :mmd_path ], 'script', 'ftpsync.pl') )
        File.exist?( @action.perl_script ).should be_true
        @action.perl_cmd.should eql( "export HOME=#{@checkout_path};perl #{File.join(@spec.parameters[ :mmd_path ], 'script')}/ftpsync.pl -l -p ftpuser=#{@ftp_username} ftppasswd=#{@ftp_password} #{@checkout_path} ftp://#{@ftp_host}/#{@ftp_path}" )
    end
end

