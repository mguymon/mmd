require 'spec/spec_helper.rb'
require 'mmd'

describe MMD::Actions::Touch do

  it "should touch a file" do

    test_file = 'spec/fixtures/touch.test'

    if File.exist?( test_file )
        File.delete( test_file )
    end

    @action = MMD::Action.new( :touch, {:checkout_path => 'spec/fixtures', :log_file => 'log/touch_spec.log' }, :file => 'touch.test' ) 

    @action.execute

    File.exist?( test_file ).should be_true

    File.delete( test_file )

  end
end