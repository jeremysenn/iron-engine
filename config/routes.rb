Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token

  resources :clients do
    resources :prime_eight_assessments, only: %i[new create show]
    resources :programs, only: %i[new create show]
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "dashboard#index"
end
