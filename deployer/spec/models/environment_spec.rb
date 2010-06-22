require 'spec/spec_helper'

describe Environment do
  before(:each) do
    @environment = create_environment()
  end

  it "should have parameters" do
    create_environment_parameter( :name => 'test123', :value => 'value123', :environment => @environment )
    create_environment_parameter( :name => 'test456', :value => 'value456', :environment => @environment )

    params = @environment.parameters
    params.size.should == 2
    params[:test123].should == 'value123'
    params[:test456].should == 'value456'
  end
end
