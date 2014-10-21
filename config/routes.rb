TellServer::Application.routes.draw do

  root to: 'pages#index'
  post '/land', to: 'pages#land'

  devise_for :users, :controllers => { :registrations => "registrations" }

  put '/users/facebook', to: 'social#facebook'

  resources :users, except: [:new, :create]
  resources :versions
  resources :locations do
    resources :comments
  end
  get 'metrics', to: 'metrics#index'
end
