Rails.application.routes.draw do
  get "sign_up", to: "registrations#new"
  post "sign_up", to: "registrations#create"

  get "sign_in", to: "sessions#new"
  post "sign_in", to: "sessions#create"

  delete "logout", to: "sessions#destroy"

  root "main#index"

  resources :url_creations, only: [:index, :new, :create, :redirect, :show] do
    resources :short_urls, only: [:new, :create] do
      resources :geolocations, only: [:new, :create]
    end
  end

  get '/:short_path/stats', to: "url_creations#show"
  get "/:short_path", to: "url_creations#redirect"
  
  get "error", to: "main#error"

end
