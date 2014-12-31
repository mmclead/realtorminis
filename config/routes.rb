Realtorminis::Application.routes.draw do

  root 'static_pages#index'
  get 'static_pages/index'

  get "/home", to: 'page#home', as: 'home'
  get "/about", to: 'page#about', as: 'about'
  get "/pricing", to: 'page#pricing', as: 'pricing'
  get "/contact", to: 'page#contact', as: 'contact'
  
  devise_for :users

  resources :users, only: [:index, :show] do
    resource :profile
    resources :listings
    resources :sites
  end

  resources :listings do
    patch :publish, on: :member
    
    resources :photos, :only => [:index, :create, :destroy] do
      get :generate_key, :on => :collection
    end   
  end
  

end
