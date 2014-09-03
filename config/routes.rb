TellServer::Application.routes.draw do
  devise_for :users, :controllers => { :registrations => "registrations", omniauth_callbacks: 'omniauth_callbacks' }

  resources :users, except: [:new, :create]
  resources :locations do
    resources :comments
    collection do
      post :scan
    end
  end
end
