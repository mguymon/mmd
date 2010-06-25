require 'spec/spec_helper.rb'
require 'mmd'

describe MMD::Spec do

    before(:all) do
        environ = Environment.find_by_name( 'test.slackworks.com' )
        environ.delete if environ
        
        @spec = create_spec(
          :environment => {
            :deployment_mode => "development",
            :name => 'test.slackworks.com' } )
        @checkout_path = @spec.checkout_path

        if not File.exists?( @checkout_path )
          FileUtils.mkdir_p( @checkout_path )
        end
    end

    it "should have 12 lifecycles" do
        MMD::Spec::LIFECYCLE_STAGES.size.should eql( 15 )
    end

    it "should load all lifecycles from config" do
        @spec.execute( VALID_MMD_LIFECYCLES )
        @spec.lifecycles.size.should eql( 15 )
    end

    it "should raise ConfigError for invalid lifecycles from config" do
        lambda{ 
            @spec.execute( INVALID_MMD_LIFECYCLES )
        }.should raise_error( MMD::SpecError )
    end

    it "should execute actions in config" do
      remove_matching_files( File.join( @checkout_path, "configuration_actions.test" ) )
      file_name = File.join( @checkout_path, "configuration_actions.test" )
      test_file = create_text_file( file_name, "w+")
      @spec.execute( MMD_ACTIONS )
      @spec.lifecycles.size.should eql( 3 )
      @spec.lifecycles.each do |stage,lifecycle|
          lifecycle.actions.each do |action|
            action.finished.should be_true
          end
      end
      File.exist?( File.join( @checkout_path, "configuration_actions.test_1"  ) ).should be_false
      File.exist?( File.join( @checkout_path, "configuration_actions.test_2"  ) ).should be_false
      File.exist?( File.join( @checkout_path, "configuration_actions.test_3"  ) ).should be_true
    end

    it "should execute :all and deployment_mode of :development actions in config" do
      remove_matching_files( File.join( @checkout_path, "configuration_actions.test" ) )
      file_name = File.join( @checkout_path, "configuration_mode.test" )
      test_file = create_text_file( file_name, "w+")
      File.exist?( file_name ).should be_true
      
      @spec.execute( MMD_DEPLOYMENT_ACTIONS )
      @spec.deployment_mode.should == :development
      @spec.lifecycles.size.should eql( 3 )
      @spec.lifecycles.each do |stage,lifecycle|
          lifecycle.actions.each do |action|
              if action.mode == :development or action.mode == :all
                action.finished.should be_true
              else
                action.finished.should be_false
              end
          end
      end
      File.exist?( File.join( @checkout_path, "configuration_mode.test_1" ) ).should be_false
      File.exist?( File.join( @checkout_path, "configuration_mode.test_2" ) ).should be_true
      File.exist?( File.join( @checkout_path, "configuration_mode.test_3" ) ).should be_false
    end

    it "should execute :all and environment of test.slackworks.com actions in config" do

      file_name = File.join( @checkout_path, "configuration_environment.test" )
      remove_matching_files( file_name )
      test_file = create_text_file( file_name, "w+")
      File.exists?( file_name ).should be_true

      @spec.execute( MMD_ENVIRONMENT_ACTIONS )
      @spec.lifecycles.size.should eql( 3 )
      @spec.lifecycles.each do |stage,lifecycle|
          lifecycle.actions.each do |action|
              if action.mode == :development || action.mode == :all || action.environment == 'test.slackworks.com'.to_sym
                action.finished.should be_true
              else
                action.finished.should be_false
              end
          end
      end
      File.exist?( File.join( @checkout_path, "configuration_environment.test_1" ) ).should be_false
      File.exist?( File.join( @checkout_path, "configuration_environment.test_2" ) ).should be_true
      File.exist?( File.join( @checkout_path, "configuration_environment.test_3" ) ).should be_false
    end
end

VALID_MMD_LIFECYCLES = <<EOF
lifecycle :config_before do

end

lifecycle :config do

end

lifecycle :config_after do

end

lifecycle :build_before do

end

lifecycle :build do

end

lifecycle :build_after do

end

lifecycle :test_before do

end

lifecycle :test do

end

lifecycle :test_after do

end

lifecycle :deploy_before do

end

lifecycle :deploy do

end

lifecycle :deploy_after do

end

lifecycle :update_before do

end

lifecycle :update do

end

lifecycle :update_after do

end
EOF

INVALID_MMD_LIFECYCLES = <<EOF
lifecycle :build! do

end

lifecycle :after_build do

end


lifecycle "deploy_before" do

end

lifecycle :deploy do

end
EOF

MMD_ACTIONS = <<EOF
    lifecycle :build do
      action :update_file do
        move "configuration_actions.test", "configuration_actions.test_1"
      end
    end


    lifecycle "deploy" do
      action :update_file do
        move "configuration_actions.test_1", "configuration_actions.test_2"
      end
    end

    lifecycle :deploy_after do
      action :update_file do
        move "configuration_actions.test_2", "configuration_actions.test_3"
      end
    end
EOF

MMD_DEPLOYMENT_ACTIONS = <<EOF
    lifecycle :build_after do
      for_deployment_mode :development do
          action :update_file do
            move "configuration_mode.test", "configuration_mode.test_1"
          end
      end
    end


    lifecycle "deploy_before" do
      action :update_file do
        move "configuration_mode.test_1", "configuration_mode.test_2"
      end
    end

    lifecycle :deploy do
      for_deployment_mode :production do
          action :update_file do
            move "configuration_mode.test_2", "configuration_mode.test_3"
          end
      end
    end
EOF

MMD_ENVIRONMENT_ACTIONS = <<EOF
    lifecycle :build_after do
      for_environment "test.slackworks.com" do
          action :update_file do
            move "configuration_environment.test", "configuration_environment.test_1"
          end
      end
    end


    lifecycle "deploy_before" do
      action :update_file do
        move "configuration_environment.test_1", "configuration_environment.test_2"
      end
    end

    lifecycle :deploy do
      for_deployment_mode "not.development" do
          action :update_file do
            move "configuration_environment.test_2", "configuration_environment.test_3"
          end
      end
    end
EOF

