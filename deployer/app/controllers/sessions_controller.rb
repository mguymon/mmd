# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem

  def new
  end

  def create
    logout_keeping_session!
    account = Account.authenticate(params[:login], params[:password])
    if account
      self.current_account = account
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      respond_to do |format|
        format.html {
            redirect_back_or_default('/')
            flash[:notice] = "Logged in successfully"
        }
        format.xml { render :xml => "<login>success</login>" }
      end
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      respond_to do |format|
        format.html {
          render :action => 'new'
        }
        format.xml { render :xml => "<login>failed</login>" }
      end
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
