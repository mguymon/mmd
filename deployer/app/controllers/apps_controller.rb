
class AppsController < ApplicationController
    before_filter :login_required
    
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
      @application = App.new(params[:app])

      if @application.save
        respond_to do |format|
          format.json do
            render :json => { :success => true, :id => @application.id}.to_json
          end
        end
      else
        respond_to do |format|
          format.json do
            render :json => { :success => false, :errors => @application.errors.full_messages }.to_json
          end
        end
      end
    end

    # GET 
    def show
      @application = App.find( params[:id] )
      respond_to do |format|
          format.html { render :file => "applications/index.json.erb", :use_full_path => true }
          format.json do
            render :json => { :success => true, :record => @application.attributes }.to_json
          end
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
