Rails.application.routes.draw do
  root 'top#index'

  resources :users, only: %i[new create]

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :ramen_shops, only: %i[index]

  resources :videos, only: %i[new create index]
end
