Rails.application.routes.draw do
  resources :parking_lots
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resource :otp_requests, only: [:create]
  resources :users, only: [:update]

  post '/validate_otp', to: 'authentication#validate_otp'
end
