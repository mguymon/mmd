class UsersController < ApplicationController
  respond_to :json

  def show
    if params[:id] != 'current'
      @user = User.find(params[:id])
    else
      @user = current_user
    end

    respond_with @user
  end
end
