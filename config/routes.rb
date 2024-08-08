Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resource :otp_requests, only: [:create]
  resources :users, only: [:update]
  resources :parking_lots, except: [:index]

  post '/validate_otp', to: 'authentication#validate_otp'
end
