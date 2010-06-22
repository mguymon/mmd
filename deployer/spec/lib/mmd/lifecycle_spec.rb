require 'spec/spec_helper.rb'
require 'mmd'

describe MMD::Lifecycle do

    before(:each) do
        @spec = create_spec()
        @lifecycle = MMD::Lifecycle.new( 'test', @spec )
    end

    it "should load action config" do
        @lifecycle.instance_eval( VALID_ACTION_CONFIG )
        @lifecycle.actions.size.should eql(1)
        lifecycle_action = @lifecycle.actions.first
        lifecycle_action.name.should eql(:update_file)
        # #lifecycle_action.class.ancestors.inspect.should include( "MMD::Actions::UpdateFile" )
        lifecycle_action.options[:file_path].should eql( "somewhere that is here.txt" )
    end

    it "should raise ActionError for invalid config" do
        lambda{ @lifecycle.instance_eval( INVALID_ACTION_CONFIG ) }.should raise_error(ActionError)
    end

    it "should load action for specific environment" do
        @lifecycle.instance_eval( ACTION_FOR_ENVIRONMENT_CONFIG )
        @lifecycle.actions.size.should eql(2)
        @lifecycle.actions.each do |action|
            action.mode.should eql( :all )
            action.environment.should eql( "fiddy.igicom.com".to_sym )
        end
    end

    it "should load action for specific deployment mode" do
        @lifecycle.instance_eval( ACTION_FOR_DEPLOYMENT_MODE_CONFIG )
        @lifecycle.actions.size.should eql(2)
        @lifecycle.actions.each do |action|
            action.environment.should eql( :all )
            action.mode.should eql( :development )
        end
    end

    it "should get and set params" do
      @lifecycle = MMD::Lifecycle.new( 'test', @spec ) do
        param :test => true
      end
      @lifecycle.param( :test ).should eql( true )
      @lifecycle.parameters.get( :test ).should eql( true )

      @lifecycle = MMD::Lifecycle.new( 'test', @spec ) do
        params :lemon => "very", "logging" => 11
      end

      @lifecycle.param( :lemon ).should eql( "very" )
      @lifecycle.parameters.get( :lemon ).should eql( "very" )
      @lifecycle.param( :logging ).should eql( 11 )      
      @lifecycle.parameters.get( :logging ).should eql( 11 )
    end
end

VALID_ACTION_CONFIG = <<EOF
  action :update_file, :file_path => "somewhere that is here.txt" do
    replace "blah", "woot"
    expand_tokens :file_destination=> "somewhere/else.txt"
  end
EOF

INVALID_ACTION_CONFIG = <<EOF
  action :remove do
    file "test.txt"
  end

  action :lemon
EOF

ACTION_FOR_ENVIRONMENT_CONFIG = <<EOF
  for_environment :"fiddy.igicom.com" do
      action :update_file, :file_path => "somewhere that is here.txt" do
        replace "blah", "woot"
        expand_tokens :file_destination=> "somewhere/else.txt"
      end
      action :perl_ftp_sync
  end
EOF

ACTION_FOR_DEPLOYMENT_MODE_CONFIG = <<EOF
  for_deployment_mode :development do
      action :update_file, :file_path => "somewhere that is here.txt" do
        replace "blah", "woot"
        expand_tokens :file_destination=> "somewhere/else.txt"
      end
      action :perl_ftp_sync
  end
EOF

