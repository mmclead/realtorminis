Realtorminis::Application.routes.draw do

  comfy_route :cms_admin, :path => '/admin'

  # Make sure this routeset is defined last
  

  root 'static_pages#index'
  get 'static_pages/index'

  get "/home", to: 'page#home', as: 'home'
  get "/about", to: 'page#about', as: 'about'
  get "/pricing", to: 'page#pricing', as: 'pricing'
  get "/contact", to: 'page#contact', as: 'contact'
  
  devise_for :users

  resources :users do
    resource :profile
    resource :account, only: [:show]
    resources :listings
    resources :sites
    resources :credits
  end

  resources :listings do
    patch :publish, on: :member
    
    resources :photos, :only => [:index, :create, :destroy] do
      get :generate_key, :on => :collection
    end   
  end
end
