require 'spec/spec_helper.rb'
require 'net/http'
require 'uri'
require 'mmd'

describe MMD::Actions::Cap do
 
  it "should run capistrano tasks" do
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

    source_manager = MMD::SourceManager.new(:subversion, parameters )
    source_manager.checkout
    parameters[:checkout_path] = source_manager.checkout_path

    logger = mock("logger", :null_object => true)
    MMD::Actions::Logger.stub!(:new).and_return( logger )
    logger.should_receive(:info).with( "username cannot be overridden" )


    @action = MMD::Action.new( :cap, parameters, :file => 'deploy.rb' ) do
      task 'mmd:echo'
    end
    @action.execute
  end
end