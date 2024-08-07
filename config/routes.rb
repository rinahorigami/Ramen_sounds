Rails.application.routes.draw do
  root 'top#index'

  resources :users, only: %i[new create]
end
