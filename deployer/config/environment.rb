# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  config.gem 'log4r'
  config.gem 'jruby-openssl', :lib => 'openssl'
  config.gem "net-ssh", :lib => 'net/ssh'
  config.gem 'net-scp', :lib => 'net/scp'
  config.gem 'net-sftp', :lib => 'net/sftp' #, :version => '2.0.4'
  config.gem 'net-ssh-gateway', :lib => 'net/ssh/gateway'
  config.gem 'capistrano'
  #config.gem 'buildr'
  #config.gem 'activerecord-jdbcmysql-adapter', :lib => 'active_record/connection_adapters/jdbcmysql_adapter'
  #config.gem 'jruby-rack'
  #config.gem 'rack'

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de

  config.action_controller.session = {
    :session_key => '_deployer_session',
    :secret      => 'b3edbcd5fb37f94da2d5464d1644b5a07b1d1c03327d250580fe6eb0afd323203616d3ad91f7083c0ef046be6e8419da476b3d54efea7968d728bbe00b61738a'
  }
end

# Load the Java Deployer Service
unless ENV['SKIP_JAVA'] == 'true'
  require 'powerplant/deployer'

  begin
    DeployProcess.destroy_all
  rescue
    RAILS_DEFAULT_LOGGER.error( "Failed to remove all stale DeployProcess: #{$!.inspect}" )
  end

  begin
    Deploy.update_all( "is_running = false" )
  rescue
    RAILS_DEFAULT_LOGGER.error( "Failed to reset all Deploy to non-running status: #{$!.inspect}" )
  end
end
