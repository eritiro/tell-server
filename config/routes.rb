TellServer::Application.routes.draw do
  resources :versions

  devise_for :users, :controllers => { :registrations => "registrations" }

  put '/users/facebook', to: 'social#facebook'

  resources :users, except: [:new, :create]
  resources :locations do
    resources :comments
    collection do
      post :scan
    end
  end
  get 'metrics', to: 'metrics#index'
end
