Realtorminis::Application.routes.draw do

  get "/home", to: 'page#home', as: 'home'
  get "/about", to: 'page#about', as: 'about'
  get "/pricing", to: 'page#pricing', as: 'pricing'
  get "/contact", to: 'page#contact', as: 'contact'
  
  devise_for :users

  resources :users, only: [:index, :show] do
    resources :listings
    resources :sites
  end

  resources :listings do 
    resources :photos, :only => [:index, :create, :destroy] do
      get :generate_key, :on => :collection
    end   
  end
  
  root 'page#home'

end
