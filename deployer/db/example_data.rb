module FixtureReplacement
    attributes_for :client do |a|                
        a.name       = String.random
        a.short_name = String.random
    end

    attributes_for :project do |a|        
        a.name       = String.random
        a.short_name = String.random
        a.desc       = String.random
        a.client     = create_client
    end

    attributes_for :app do |a|
        a.name       = String.random
        a.short_name = String.random
        a.desc       = String.random
        a.project    = create_project
    end

    attributes_for :environment do |a|
        a.name       = String.random
        a.short_name = String.random
        a.desc       = String.random
        a.deployment_mode = "testing"
        a.is_production = false
        a.app        = create_app
    end

    attributes_for :environment_parameter do |a|
        a.name  = String.random
        a.value = String.random
    end

    attributes_for :deploy_process do |a|

    end

    attributes_for :deploy do |a|
      deploy_path = File.join( MMD::Option.workspace, String.random )
      a.deployed_at = Time.now
      a.is_running  = false
      a.is_success  = true
      a.log_file    = File.join( deploy_path, "#{String.random}.log" )
      a.path        = deploy_path
      a.deployed_by = create_account
      a.environment = create_environment
    end

    attributes_for :account do |a|
      a.email = "#{String.random}@#{String.random}.com"
      a.login = String.random
      
      password = String.random
      a.password = password
      a.password_confirmation = password
    end
end