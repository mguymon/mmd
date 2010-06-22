require File.dirname(__FILE__) + '/../spec_helper'

describe HomeController do
  fixtures :accounts

  #Delete these examples and add some real ones
  it "should use HomeController" do
    controller.should be_an_instance_of(HomeController)
  end


  describe "GET 'index'" do
    it "should be successful" do
      login_as :quentin
      get 'index'
      response.should be_success
    end
  end
end
