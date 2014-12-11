TellServer::Application.routes.draw do
  resources :feeds

  root to: 'pages#index'
  get '/download', to: 'pages#download'
  get '/app',      to: 'pages#download'

  get '/privacy', to: 'pages#privacy'

  devise_for :users, :controllers => { :registrations => "registrations" }

  get '/users/profile', to: 'users#profile'
  put '/users/facebook', to: 'social#facebook'
  put '/users/photo_select', to: 'social#photo_select'

  resources :users, except: [:new, :create] do
    resources :messages, except: [:new]
    collection do
      post :alert
      put :leave
    end
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


  resources :notifications, only: [:index, :destroy]

end
