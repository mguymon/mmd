
class HomeController < ApplicationController
  layout 'default'
  before_filter :login_required
  
  def index
  end
end
