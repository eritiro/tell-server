TellServer::Application.routes.draw do
  devise_for :users, :controllers => { :registrations => "registrations" }
  resources :users, except: [:new, :create]
  resources :locations do
    resources :comments
  end
end
