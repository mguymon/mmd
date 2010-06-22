# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path(File.join(File.dirname(__FILE__),'..','config','environment'))
require 'spec/autorun'
require 'spec/rails'
require 'log4r'

include AuthenticatedTestHelper

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

  # == Fixtures
  #
  # You can declare fixtures for each example_group like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so right here. Just uncomment the next line and replace the fixture
  # names with your fixtures.
  #
  # config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
  #
  # You can also declare which fixtures to use (for example fixtures for test/fixtures):
  #
  # config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  #
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # 
  # config.mock_with :mocha config.mock_with :flexmock config.mock_with :rr
  
  Spec::Runner.configure do |config|
    config.include FixtureReplacement
  end
end

def build_deploy( user_options = {} )
  options = {
    :client => {},
    :project => {},
    :application => {},
    :environment => {},
    :deploy => {} }.merge(user_options)

  client  =     create_client(  options[:client])
  project =     create_project( options[:project].merge( :client => client ) )
  application = create_app(     options[:application].merge( :project => project ) )
  environment = create_environment( options[:environment].merge( :app => application ) )
  create_environment_parameter( :name => "scm", :value => "subversion", :environment => environment )
  deploy =      create_deploy(  options[:deploy].merge( :environment => environment ) )

  if options[:deploy][:path].nil?
    deploy.path = MMD::Deployer.create_deploy_path( environment )
  end
  if options[:deploy][:log_file].nil?
    deploy.log_file = File.join( MMD::Deployer.create_deploy_path( environment ), "deploy.#{DateTime.now.strftime('%Y%m%d%H%M%S')}.log" )
  end
  deploy.save

  deploy
end


def remove_matching_files( path )
  like = "*#{File.basename(path)}*"
  base_path = File.dirname( path )
  Dir.glob( File.join( base_path, "*#{like}*" ) ) do |file|
      RAILS_DEFAULT_LOGGER.info( "Removing file #{file}")
      FileUtils.rm( file )
  end
end

def create_text_file( path, text="test" )
  RAILS_DEFAULT_LOGGER.info( "Creating file #{path}")
  test_file = File.new( path, "w+")
  test_file.puts text
  test_file.flush

  test_file
end

def create_spec( user_params={} )
    params = { :log_file => 'tmp/test.log' }.merge( user_params )
    deploy = build_deploy( params )
    deploy.log_file = params[:log_file]

    params[:deploy_path] = deploy.path
    params[:checkout_path] = "#{deploy.path}/checkout"

    MMD::Deployer::Config.set( params.merge( deploy.environment.parameters ) )

    spec =
      MMD::Spec.new( deploy.environment.name, deploy.environment.deployment_mode, MMD::Deployer::Config )

    spec
end
