ActionController::Routing::Routes.draw do |map|
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'accounts', :action => 'create'
  map.signup '/signup', :controller => 'accounts', :action => 'new'

  map.resources :accounts

  map.resource :session

  map.resources :clients, :collection => { :tree => :post } do |client|
    client.resources :projects do |project|
      project.resources :applications do |app|
        app.resources :environments do |environment|
          environment.resources :deploys
        end
      end
    end
  end

  map.resources :projects
  
  map.resources :apps
  
  map.resources :environments
  
  map.resources :deploys

  map.root :controller => "home"

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
