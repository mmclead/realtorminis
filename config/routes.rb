Realtorminis::Application.routes.draw do

  comfy_route :cms_admin, :path => '/admin'

  root 'page#home'

  get "/home", to: 'page#home', as: 'home'
  get "/about", to: 'page#about', as: 'about'
  get "/pricing", to: 'page#pricing', as: 'pricing'
  get "/contact", to: 'page#contact', as: 'contact'
  
  devise_for :users

  resources :users do
    resource :profile
    resource :account, only: [:show] do
      get :payment_details
    end
    resources :listings
    resources :sites
    resources :credits
  end

  resources :listings do
    patch :publish, on: :member
    get :check_availability, on: :collection
    
    resources :photos, :only => [:index, :create, :destroy] do
      get :generate_key, :on => :collection
      post :sort_photos, :on => :collection
    end   
  end
end
