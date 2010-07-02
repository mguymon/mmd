
class ClientsController < ApplicationController
    before_filter :login_required
    
    def index
      @clients = Client.find(:all)
      respond_to do |format|
        records = @clients.map do |client|
            { :guid      => client.id,
              :type      => client.class.name,
              :name      => client.name,
              :short_name => client.short_name }
          end

        format.html {
          render :text => { :records => records, :ids => @clients.map(&:id) }.to_json
        }

        format.text {
          render :text => { :records => records, :ids => @clients.map(&:id) }.to_json
        }

        format.json {
          render :json => clients_to_json( @clients )
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

        format.json do
          render :json => { :success => true, :record => client.attributes }.to_json 
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

    protected
    def clients_to_json( clients )

      json = clients.map do |client|
        clients_hash = {
          'text' => client.name,
          'id' => "client-#{client.id}",
          'recordId' => client.id,
          'recordType' => 'client',
          'leaf' => client.projects.size == 0 }

        clients_hash['children'] = client.projects.map do |project|
          projects_hash = {
            'text' => project.name,
            'id' => "project-#{project.id}",
            'recordId' => project.id,
            'recordType' => 'project',
            'leaf' => project.apps.size == 0
          }

          projects_hash['children'] = project.apps.map do |app|
            app_hash = {
              'text' => app.name,
              'id' => "app-#{app.id}",
              'recordId' => app.id,
              'recordType' => 'app',
              'leaf' => app.environments.size == 0
            }

            app_hash['children'] = app.environments.map do |enviro|
              {
                'text' => enviro.name,
                'id' => "environment-#{enviro.id}",
                'recordId' => enviro.id,
                'recordType' => 'environment',
                'leaf' => true
              }
            end

            app_hash
          end

          projects_hash
        end

        clients_hash
      end
      
      
      json.to_json
    end
end
