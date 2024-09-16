Rails.application.routes.draw do
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  
  root 'top#index'

  resources :users, only: %i[new create]

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :ramen_shops, only: %i[index show] do
    member do
      get 'map'
    end
  end

  resources :videos do
    resources :comments, only: %i[create edit update destroy]
    resource :like, only: [:create, :destroy]
  end

  resources :password_resets, only: [:new, :create, :edit, :update]
end
