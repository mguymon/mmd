require 'spec/spec_helper.rb'
require 'mmd'

describe MMD::Actions::Buildr do

  it "should run buildr tasks" do



    @action = MMD::Action.new( :buildr_action, {:checkout_path => 'spec/fixtures', :log_file => 'log/buildr_spec.log' } ) do
      task 'clean'
    end

    @action.execute

  end
end
