TellServer::Application.routes.draw do

  devise_for :users
  resources :users, except: [:new, :create]
  resources :locations do
    resources :comments
  end
end
