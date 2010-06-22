
class AppsController < ApplicationController
    #before_filter :login_required
    
    def index
      @applications = App.find_all_by_project_id( params[:project_id] )
      respond_to { |format|        
        format.json
        format.html { render :file => "applications/index.json.erb", :use_full_path => true }
        format.xml { render( :xml => @applications.to_xml() ) }
      }
    end
    
    # GET 
    def new
      # return an HTML form for describing the new account
    end

    # POST 
    def create
      # create an account
    end

    # GET 
    def show
      @application = App.find( params[:id] )
      respond_to do |format|
          format.json { render :file => "applications/index.json.erb", :use_full_path => true }
          format.html { render :file => "applications/index.json.erb", :use_full_path => true }
      end
    end

    # GET 
    def edit
      # return an HTML form for editing the account
    end

    # PUT 
    def update
      # find and update the account
    end

    # DELETE 
    def destroy
      # delete the account
    end
end
