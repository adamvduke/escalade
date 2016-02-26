Rails.application.routes.draw do
  root to: 'visitors#index'
  devise_for :users, skip: [:registration, :password, :confirmation]
  resources :users, only: [:show, :index] do
    resources :sites
  end
end
