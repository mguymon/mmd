require 'test_helper'

class PlanTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

describe Plan do
  describe "instance" do
    let(:plan) { FactoryGirl.create(:plan) }

    it 'should have a config' do
      assert_equal( [{"foo"=>"bar"}, {"w00t"=>"rawr"}], plan.config )
    end
  end
end