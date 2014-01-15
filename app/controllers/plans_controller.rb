class PlansController < ApplicationController
  respond_to :json

  def index
    @plans = current_user.plans
    respond_with @plans
  end

  def show
    id = params[:id]
    @plan = current_user.plans.where('plans.id = ? OR plans.slug = ?', id, id).first
    respond_with @plan, methods: :config
  end

end
