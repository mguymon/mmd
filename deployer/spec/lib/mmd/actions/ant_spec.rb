require 'spec/spec_helper.rb'
require 'mmd'

describe MMD::Actions::Ant do

  it "should run ant tasks" do

    if File.exist?( 'log/ant_spec.log' )
        File.delete( 'log/ant_spec.log' )
    end

    @action = MMD::Action.new( :ant, {:checkout_path => 'spec/fixtures', :log_file => 'log/ant_spec.log' }, :build_xml => 'build.xml' ) do
      task 'test'
    end

    @action.execute

    File.exist?( 'log/ant_spec.log' ).should be_true

    log = ""
    file = File.open("log/ant_spec.log")
    file.each { |line| log << line }
    file.close

    # Assert that ant task is running
    log.should match( /Test for Ant Spec\!/ )

    File.delete( 'log/ant_spec.log' )

  end
end