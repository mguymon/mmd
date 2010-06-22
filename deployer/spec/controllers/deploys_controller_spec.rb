require File.dirname(__FILE__) + '/../spec_helper'

describe DeploysController do
  fixtures :accounts
  
  #Delete this example and add some real ones
  it "should use DeploysController" do
    controller.should be_an_instance_of(DeploysController)
  end

  it "should execute a deploy" do
    login_as(:quentin)
    enviro = create_environment()
    create_environment_parameter( :name => 'scm',  :value => 'subversion',  :environment => enviro )
    create_environment_parameter( :name => 'svn_url',  :value => 'svn_url',  :environment => enviro )
    create_environment_parameter( :name => 'svn_root', :value => 'svn_root', :environment => enviro )
    create_environment_parameter( :name => 'svn_path', :value => 'svn_path', :environment => enviro ) 

    app = enviro.app
    project = app.project
    client = project.client

    deploy_path = File.join( MMD::Option.workspace, client.short_name, project.short_name, app.short_name, enviro.short_name )

    MMD::Option.should_receive(:should_use_threads).and_return( false )

    subversion_util_mock = mock( "SubversionUtil Mock")
    SubversionUtil.should_receive(:new).and_return( subversion_util_mock )
    subversion_util_mock.should_receive(:export).with( "svn_url/svn_root/svn_path", File.join( deploy_path, "checkout" ), { :force => true } )

    deployer = MMD::Deployer.new
    MMD::Deployer.should_receive( :new ).and_return( deployer )
    deployer.should_receive( :read_mmd_file ).with( File.join( deploy_path, 'checkout', 'mmd.rb') ).and_return( "mmd config" )

    File.should_receive( :exist? ).with( File.join( deploy_path, 'checkout', 'mmd.rb') ).and_return( true )

    deploy = Deploy.new
    Deploy.should_receive(:new).and_return(deploy)

    mmd_config_mock = mock( "MMD::Spec mock")
    MMD::Spec.should_receive(:new).with(
      enviro.name, enviro.deployment_mode, anything() ).and_return( mmd_config_mock )
    mmd_config_mock.should_receive(:execute ).with( "mmd config" )
    
    post :create, :environment_id => "#{enviro.id}", :deployed_by => 'quentin'
  end

  it "should execute a deploy from svn" do
    login_as(:quentin)

    svn_repo = "file://#{RAILS_ROOT}/spec/svn_repo"

    enviro = create_environment()
    create_environment_parameter( :name => 'scm',  :value => 'subversion',  :environment => enviro )
    create_environment_parameter( :name => 'svn_url',  :value => svn_repo,  :environment => enviro )
    create_environment_parameter( :name => 'svn_root', :value => 'test', :environment => enviro )
    create_environment_parameter( :name => 'svn_path', :value => 'trunk', :environment => enviro )

    MMD::Option.should_receive(:should_use_threads).and_return( false )

    post :create, :environment_id => "#{enviro.id}", :deployed_by => 'quentin'

    app = enviro.app
    project = app.project
    client = project.client
    
    test_file = File.join( MMD::Option.workspace, client.short_name, project.short_name, app.short_name, enviro.short_name, "checkout", "test.txt3" )
    File.exists?( test_file ).should eql(true)

  end
end
