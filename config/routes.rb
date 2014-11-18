TellServer::Application.routes.draw do
  root to: 'pages#index'
  get '/app', to: 'pages#app'
  post '/land', to: 'pages#land'

  devise_for :users, :controllers => { :registrations => "registrations" }

  get '/users/profile', to: 'users#profile'
  put '/users/facebook', to: 'social#facebook'
  put '/users/photo_select', to: 'social#photo_select'

  resources :users, except: [:new, :create] do
    resources :messages
    member do
      post :invite
    end
  end
  resources :versions
  resources :locations do
    resources :attendees, only: :index
  end
  put 'locations/:location_id/attendees', to: 'attendees#attend'
  delete 'locations/:location_id/attendees', to: 'attendees#leave'

  get 'metrics', to: 'metrics#index'


  resources :notifications, only: :index

end
