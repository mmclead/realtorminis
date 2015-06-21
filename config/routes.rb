Realtorminis::Application.routes.draw do

  comfy_route :cms_admin, :path => '/admin'

  root 'page#home'

  get "/home", to: 'page#home', as: 'home'

  get "/manifest", to: 'manifest#index', as: 'manifest'
  
  devise_for :users

  resources :users

  resource :profile
  resource :account, only: [:show] do
    get :payment_details
  end
  resources :domain_names, only: [:create]
  resources :credits
  
  resources :domain_names, only: [] do
    get :check_availability, on: :collection
    get :check_status, on: :member
  end

  resources :listings do
    patch :publish, on: :member
    get :check_availability, on: :collection
    
    resources :photos, :only => [:index, :create, :destroy] do
      get :generate_key, :on => :collection
      post :sort_photos, :on => :collection
    end   
  end

  get '*unmatched_route', to: 'page#home'
end
