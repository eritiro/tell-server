TellServer::Application.routes.draw do

  devise_for :users
  resources :locations do
    resources :comments
  end
end
