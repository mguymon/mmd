
class ClientsController < ApplicationController
    #before_filter :login_required
    
    def index
      @clients = Client.find(:all)
      respond_to do |format|
        records = @clients.map do |client|
            { :guid      => client.id,
              :type      => client.class.name,
              :name      => client.name,
              :short_name => client.short_name
            }
          end

        format.html {
          render :text => { :records => records, :ids => @clients.map(&:id) }.to_json
        }

        format.text {
          render :text => { :records => records, :ids => @clients.map(&:id) }.to_json
        }

        format.xml { render( :xml => @clients.to_xml() ) }
      end
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
      client = Client.find( params[:id] )
      respond_to do |format|
        records = [
            { :guid      => client.id,
              :type      => client.class.name,
              :name      => client.name,
              :short_name => client.short_name
            }]

        format.html {
          render :text => { :records => records, :ids => @clients.map(&:id) }.to_json
        }

        format.text {
          render :text => { :records => records, :ids => @clients.map(&:id) }.to_json
        }
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
