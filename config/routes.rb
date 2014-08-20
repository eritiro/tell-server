TellServer::Application.routes.draw do

  devise_for :users
  resources :users
  resources :locations do
    resources :comments
  end
end
