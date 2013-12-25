Mmd::Application.routes.draw do
  devise_for :users

  resources :users
  resources :nav

  root :to => 'home#index'
end
