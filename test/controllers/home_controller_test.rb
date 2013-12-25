require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
end

describe HomeController do
  include Devise::TestHelpers
  include Warden::Test::Helpers
  Warden.test_mode!

  after do
    Warden.test_reset!
  end

  describe '#index' do
    before :each do
      @user = FactoryGirl.create(:user)
      sign_in :user, @user

      get :index
    end

    it 'should be a success' do
      assert_response :success
    end

    it 'should return response 200' do
      assert_match response.code, '200'
    end

    it 'should have html content type' do
      assert_match 'text/html; charset=utf-8', response.headers['Content-Type']
    end

    it 'should assign plans' do
      assert_equal assigns(:plans).to_a, @user.plans.to_a
    end

    it 'should assign current plan' do
      assert_equal assigns(:current_plan), @user.plans.first
    end
  end

end
