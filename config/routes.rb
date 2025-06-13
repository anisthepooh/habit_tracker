Rails.application.routes.draw do
  get "/up", to: proc { [ 200, {}, [ "OK" ] ] }

  # authentication
  get "signup", to: "registrations#new", as: :new_registration
  post "signup", to: "registrations#create", as: :registration
  resource :session, except: [ :new ]
  get "login", to: "sessions#new", as: :new_session
  resources :passwords, param: :token
  resources :habits do
    patch :archive, on: :member
    resources :entries
  end
  get :completed_habits, to: "habits#completed_index"
  get :archived_habits, to: "habits#archived_index"
  get :entries, to: "entries#index_all"
  resources :users, except: [ :index ] do
    get :finish_profile, to: "users#new_user",  on: :member
    get :report
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
  get :home, to: "pages#home"
  get :become_beta, to: "pages#become_beta"
  get "privacy_policy", to: "pages#privacy_policy", as: :privacy_policy
  get "change_log", to: "pages#change_log", as: :change_log


  # Admin
  namespace :admin do
    get "dashboard", to: "dashboard#index"
    get "design_system", to: "design_system#index"
    resources :users
    resources :habits
    resources :entries
    resources :changelog_entries
    resources :communications
  end
  mount Flipper::UI.app(Flipper) => "/flipper"
end
