require 'spec/spec_helper.rb'
require 'subversion_util'

describe SubversionUtil do
  before(:each) do
    @subversion = SubversionUtil.new
  end

  it "should export" do
    # @subversion.export("http://svn.Slackworks.com:1111/svn/Slackworks/mighty_mighty_deployer/deployer/trunkspec", "tmp/test_export")
  end
end

