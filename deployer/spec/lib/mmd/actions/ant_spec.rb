require 'spec/spec_helper.rb'
require 'mmd'

describe MMD::Actions::Ant do

  it "should run ant tasks" do
    
    @action = MMD::Action.new( :ant, {:checkout_path => 'spec/fixtures'}, :build_xml => 'build.xml' ) do
      task 'test'
    end
    @action.execute
  end
end