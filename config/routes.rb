Rails.application.routes.draw do
  # authentication
  get "signup", to: "registrations#new", as: :new_registration
  post "signup", to: "registrations#create", as: :registration
  resource :session, except: [ :new ]
  get "login", to: "sessions#new", as: :new_session
  resources :passwords, param: :token
  resources :habits do
    resources :entries
  end
  resources :users, except: [ :index ] do
    get :finish_profile, to: "users#new_user",  on: :member
  end
  patch "croppable/:id", to: "users#croppable", as: "croppable"
   # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

   # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
   # Can be used by load balancers and uptime monitors to verify that the app is live.

   # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
   get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
   get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "pages#home"
end
