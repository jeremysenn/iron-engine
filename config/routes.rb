Rails.application.routes.draw do
  get "favicon.ico", to: redirect("/icon.png", status: 301)

  resource :session
  resource :registration, only: %i[new create]
  resources :passwords, param: :token

  resources :clients do
    resources :map_assessments, only: %i[new create show edit update]
    resources :prime_eight_assessments, only: %i[new create show edit update]
    resources :programs, only: %i[new create show] do
      collection do
        get :form_options
        get :rep_scheme_preview
      end
    end
    resources :workouts, only: %i[show update]
    resources :session_exercises, only: %i[update]
  end

  resources :exercises, only: %i[index show new create edit update]

  # Coach: manage share tokens
  resources :clients, only: [] do
    resource :share_token, only: %i[create destroy], controller: "client_share_tokens"
  end

  # Client-facing shared pages (magic link, no auth required)
  scope "/s/:token", as: :shared do
    get "/", to: "shared#show", as: ""
    get "/workouts/:id", to: "shared/workouts#show", as: :workout
    patch "/workouts/:id", to: "shared/workouts#update"
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "dashboard#index"
end
