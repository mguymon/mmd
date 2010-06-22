class EnvironmentsController < ApplicationController
    #before_filter :login_required
    
    def index

        if ( params[:production] == "true" ) 
            @environments = Environment.find_all_by_app_id( params[:application_id])
        else
            @environments = Environment.find_all_by_app_id( params[:application_id], :conditions => [ "is_production = false"])
        end
        
        respond_to { |format|        
            format.json
            format.html { render :file => "environments/index.json.erb", :use_full_path => true }
            format.xml { render( :xml => @environments.to_xml( :include => { :deploy_process => {:include => :deploy} } ) ) }
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
    def show()
        @environment = Environment.find( params[:id] )
        respond_to do |format|
            format.json { render :file => "environments/index.json.erb", :use_full_path => true }
            format.html { render :file => "environments/index.json.erb", :use_full_path => true }
            format.xml { render( :xml => @environment.to_xml( :include => { :deploy_process => {:include => :deploy} } ) ) }
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
