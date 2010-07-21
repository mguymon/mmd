
class ProjectsController < ApplicationController
    before_filter :login_required
    
    def index
      @projects = Project.find_all_by_client_id( params[:client_id] )
      respond_to { |format|        
        format.json
        format.html { render :file => "projects/index.json.erb", :use_full_path => true }
        format.xml { render( :xml => @projects.to_xml() ) }
      }
    end
    
    # GET 
    def new
      # return an HTML form for describing the new account
    end

    # POST 
    def create
      @project = Project.new(params[:project])

      if @project.save
        respond_to do |format|
          format.json do
            render :json => { :success => true, :id => @project.id}.to_json
          end
        end
      else
        respond_to do |format|
          format.json do
            render :json => { :success => false, :errors => @project.errors.full_messages }.to_json
          end
        end
      end
    end

    # GET 
    def show
      @project = Project.find( params[:id] )
      respond_to do |format|
          format.html { render :file => "projects/index.json.erb", :use_full_path => true }
          format.json do
            render :json => { :success => true, :record => @project.attributes }.to_json
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
