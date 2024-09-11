Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'sessions#new'

  namespace :admin do
    resources :users
  end
  resources :users
  resources :tasks
  
  resources :sessions, only: [:new, :create, :destroy]
end
