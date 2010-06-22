require 'spec/spec_helper.rb'
require 'mmd'
require 'mmd/actions/cap'
require 'log4r'
require 'fileutils'
require 'capistrano/configuration'

include_class "powerplant.deploy.LiveWire"

describe MMD::Deployer do
    before(:each) do
        @deployer = MMD::Deployer.new
        @deploy_path = File.join( MMD::Option.workspace, "deploy_test" )
        @checkout_path = File.join( @deploy_path, "checkout" )
        @src_path = File.join( @deploy_path, "src" )

        if not File.directory? @checkout_path
          FileUtils.mkdir_p( @checkout_path )
        end

        if not File.directory? @deploy_path
          FileUtils.mkdir_p( @deploy_path )
        end

        if not File.directory? @src_path
          FileUtils.mkdir_p( @src_path )
        end

    end

    it "should execute simple deploy" do
        remove_matching_files( File.join( @checkout_path, "deployer_spec.test" ) )
        log_file = File.join( @deploy_path, "deploy.#{DateTime.now.strftime('%Y%m%d%H%M%S')}.log" )
        create_text_file(  File.join( @src_path, "deployer_spec.test"), "w+" )

        file_name = File.join( @checkout_path, "mmd.rb" )
        test_file = File.new( file_name, "w+")
        test_file.puts( MMD_CONFIG )
        test_file.close

        deploy = create_deploy( :path => @deploy_path, :log_file => log_file )        

        parameters = {:scm => 'local', :log_file => log_file, :deploy_path => @deploy_path, :local_path => @src_path}

        @deployer.setup( deploy, parameters )

        # Start as separate thread
        engine = LiveWire.new( @deployer )
        engine.execute()

        File.exist?( File.join( @checkout_path, "deployer_spec.test" ) ).should be_false
        File.exist?( File.join( @checkout_path, "deployer_spec.test_1" ) ).should be_false
        File.exist?( File.join( @checkout_path, "deployer_spec.test_2" ) ).should be_false
        File.exist?( File.join( @checkout_path, "deployer_spec.test_3" ) ).should be_true
    end

    it "should execute complex deploy" do
        deploy = build_deploy()
        svn_repo = 'file://' + "#{RAILS_ROOT}/spec/svn_repo"

        enviro = deploy.environment
        create_environment_parameter( :name => 'svn_url',  :value => svn_repo,  :environment => enviro )
        create_environment_parameter( :name => 'svn_root', :value => 'complex_test', :environment => enviro )
        create_environment_parameter( :name => 'svn_path', :value => 'branches/lumox', :environment => enviro )
        create_environment_parameter( :name => 'web_host', :value => 'webhost', :environment => enviro )
        create_environment_parameter( :name => "ftp_username", :value => "ftp_username", :environment => enviro )
        create_environment_parameter( :name => "ftp_password", :value => "ftp_password", :environment => enviro )
        create_environment_parameter( :name => "ftp_host", :value => "ftp_host", :environment => enviro )
        create_environment_parameter( :name => "ftp_path", :value => "ftp_path", :environment => enviro )
        
        parameters = deploy.environment.parameters
        
        deploy_path = MMD::Deployer.create_deploy_path( enviro )
        parameters = parameters.merge( :log_file => deploy.log_file, :deploy_path => deploy_path )

        File.exists?( deploy_path ).should eql( true )
                
        @deployer.setup( deploy, parameters )

        # ftp_sync action mock       
        IO.should_receive( :popen ).with( "export HOME=#{deploy_path}/checkout;perl #{RAILS_ROOT}/script/ftpsync.pl -l -p ftpuser=ftp_username ftppasswd=ftp_password #{deploy_path}/checkout ftp://ftp_host/ftp_path" )

        # web_request action mock
        @mock_http = mock("http")
        Net::HTTP.should_receive(:new).with( "webhost", 80 ).and_return(@mock_http)
        @mock_http.should_receive(:read_timeout=).with(300)

        @mock_post = mock("post")
        Net::HTTP::Post.should_receive(:new).with( "/administrator/login.xml" ).and_return(@mock_post)
        @mock_post.should_receive( :set_form_data ).with( {"username"=>"user", "password"=>"pass"} )
        @mock_post.should_receive(:path).and_return( "path" )

        @mock_http.should_receive( :start ).and_yield( @mock_http )
        @mock_http.should_receive( :request).exactly(5).times.with( anything() )

        # Start as separate thread
        engine = LiveWire.new( @deployer )
        engine.execute()

    end

    it "should execute cap deploy" do
        deploy = build_deploy( :environment => {:deployment_mode => 'staging' } )
        svn_repo = 'file://' + "#{RAILS_ROOT}/spec/svn_repo"

        enviro = deploy.environment
        create_environment_parameter( :name => 'svn_url',  :value => svn_repo,  :environment => enviro )
        create_environment_parameter( :name => 'svn_root', :value => 'cap_test', :environment => enviro )
        create_environment_parameter( :name => 'svn_path', :value => 'trunk', :environment => enviro )
        create_environment_parameter( :name => 'cap_environment',  :value => 'staging',  :environment => enviro )
        create_environment_parameter( :name => 'cap_username', :value => 'cap test user', :environment => enviro )
        create_environment_parameter( :name => 'cap_password', :value => 'cap test password', :environment => enviro )

        parameters = deploy.environment.parameters

        deploy_path = MMD::Deployer.create_deploy_path( enviro )
        parameters = parameters.merge( :log_file => deploy.log_file, :deploy_path => deploy_path )

        File.exists?( deploy_path ).should eql( true )

        @deployer.setup( deploy, parameters )

        logger = mock("logger", :null_object => true)
        MMD::Actions::Logger.stub!(:new).and_return( logger )
        logger.should_receive(:info).with( "password cannot be overridden" )
        logger.should_receive(:info).with( "repository cannot be overridden" )
        logger.should_receive(:info).with( "scm cannot be overridden" )
        logger.should_receive(:info).with( "username cannot be overridden" )

        engine = LiveWire.new( @deployer )
        engine.execute()

    end
end

MMD_CONFIG = <<EOF
    lifecycle :build_after do      
      action :update_file do
        move "deployer_spec.test", "deployer_spec.test_1"
      end
    end


    lifecycle "deploy_before" do
      action :update_file do
        move "deployer_spec.test_1", "deployer_spec.test_2"
      end
    end

    lifecycle :deploy do      
      action :update_file do
        move "deployer_spec.test_2", "deployer_spec.test_3"
      end
    end
EOF

