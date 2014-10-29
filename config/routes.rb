TellServer::Application.routes.draw do

  root to: 'pages#index'
  post '/land', to: 'pages#land'

  devise_for :users, :controllers => { :registrations => "registrations" }

  put '/users/facebook', to: 'social#facebook'
  put '/users/photo_select', to: 'social#photo_select'

  resources :users, except: [:new, :create] do
    member do
      post :notify
    end
  end
  resources :versions
  resources :locations do
    resources :comments
  end
  get 'metrics', to: 'metrics#index'
end
