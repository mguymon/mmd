require 'test_helper'

class UsersControllerTest < ActionController::TestCase

end

describe UsersController do
  include Devise::TestHelpers
  include Warden::Test::Helpers
  Warden.test_mode!

  after do
    Warden.test_reset!
  end

  describe 'as json' do

    describe '#show' do
      before :each do
        @user = FactoryGirl.create(:user)
        sign_in :user, @user

        get :show, :id => @user.id, :format => :json
      end

      it 'should be a success' do
        assert_response :success
      end

      it 'should return json response' do
        assert_match "\"id\":#{@user.id}", response.body
      end

      it 'should return response 200' do
        assert_match response.code, '200'
      end

      it 'should have json content type' do
        assert_match 'application/json', response.headers['Content-Type']
      end

      it 'should assign user' do
        assert_equal assigns(:user),  @user
      end
    end
  end
end
