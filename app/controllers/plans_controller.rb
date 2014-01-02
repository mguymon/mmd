class PlansController < ApplicationController
  respond_to :json

  def index
    @plans = current_user.plans
    respond_with @plans
  end

  def show
    id = params[:id]
    @plan = current_user.plans.where('id = ? OR slug = ?', id, id)
    respond_with @plan
  end
end
