require 'spec/spec_helper.rb'
require 'mmd'

describe MMD::Action do

    before(:each) do
        @configuration = create_spec()
        @lifecycle = MMD::Lifecycle.new( 'test', @configuration )
        @action = MMD::Action.new( :perl_ftp_sync, @lifecycle.parameters )
    end

    it "should have valid modes" do
        @action.mode = "test"
        @action.mode.should eql( :test )

        @action.mode = :test
        @action.mode.should eql( :test )

        @action.mode = [ "one", :two, "3" ]
        @action.mode.should include( :one )
        @action.mode.should include( :two )
        @action.mode.should include( :"3" )
    end
end

