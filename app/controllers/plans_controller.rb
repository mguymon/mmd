class PlansController < ApplicationController
  respond_to :json

  def index
    @plans = current_user.plans
    respond_with @plans
  end

  def show
    @plan = find_plan
    respond_with @plan, methods: :config
  end

  def update
    @plan = find_plan

    permitted = params.permit(:name, :slug)
    @plan.config = params[:config]
    @plan.update_attributes!(permitted)
    respond_with @plan
  end

  protected
  def find_plan
    id = params[:id]
    current_user.plans.where('plans.id = ? OR plans.slug = ?', id, id).first
  end

end
