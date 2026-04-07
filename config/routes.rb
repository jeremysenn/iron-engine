Rails.application.routes.draw do
  resource :session
  resource :registration, only: %i[new create]
  resources :passwords, param: :token

  resources :clients do
    resources :map_assessments, only: %i[new create show]
    resources :prime_eight_assessments, only: %i[new create show]
    resources :programs, only: %i[new create show] do
      collection do
        get :form_options
      end
    end
    resources :workouts, only: %i[show update]
    resources :session_exercises, only: %i[update]
  end

  resources :exercises, only: %i[index show new create edit update]

  get "up" => "rails/health#show", as: :rails_health_check

  root "dashboard#index"
end
