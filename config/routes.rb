Realtorminis::Application.routes.draw do

  comfy_route :cms_admin, :path => '/admin'

  root 'page#home'

  get "/home", to: 'page#home', as: 'home'

  get "/manifest", to: 'manifest#index', as: 'manifest'
  
  devise_for :users, :controllers => { :registrations => "registrations" }

  resources :users do
    resource :profile
    resource :account, only: [:show] do
      get :payment_details
    end
    resources :listings
    resources :domain_names, only: [:create]
    resources :credits
  end

  
  resources :domain_names, only: [] do
    get :check_availability, on: :collection
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
