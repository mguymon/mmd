Mmd::Application.routes.draw do
  devise_for :users

  resources :users
  resources :plans

  root :to => 'home#index'
end
