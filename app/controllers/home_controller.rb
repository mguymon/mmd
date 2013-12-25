class HomeController < ApplicationController
  def index
    @plans = current_user.plans.order('name')
    @current_plan = @plans.first
  end
end
