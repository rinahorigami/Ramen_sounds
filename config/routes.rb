Rails.application.routes.draw do
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  namespace :admin do
    get 'login', to: 'sessions#new', as: :login
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy', as: :logout

    resources :users, only: [:index, :show, :edit, :update, :destroy]
    resources :videos, only: [:index, :show, :edit, :update, :destroy]
    resources :ramen_shops, only: [:index, :show, :new, :create, :edit, :update, :destroy]

    get '/', to: 'dashboard#index', as: :root
  end
  root 'top#index'

  get 'terms_of_service', to: 'top#terms_of_service'
  get 'privacy', to: 'top#privacy'

  resources :users, only: %i[new create show edit update]

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'google_login_api/oauth', to: 'google_login_api#oauth'
  get 'google_login_api/callback', to: 'google_login_api#callback'

  resources :ramen_shops, only: %i[index show] do
    member do
      get 'map'
    end
    collection do
      get :autocomplete
    end
  end

  resources :videos do
    resources :comments, only: %i[create edit update destroy]
    resource :like, only: [:create, :destroy]
  end

  resources :password_resets, only: [:new, :create, :edit, :update]
end
