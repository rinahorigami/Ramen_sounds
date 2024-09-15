Rails.application.routes.draw do
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
  end

  resources :videos
end
