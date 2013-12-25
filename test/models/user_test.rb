require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

describe User do
  describe 'instance' do
    let(:user) { FactoryGirl.create(:user) }

    it 'should have plans' do
      user.must_respond_to :plans
      user.plans.size.must_be :>=, 1
      user.plans[0].class.must_equal Plan
    end
  end
end
