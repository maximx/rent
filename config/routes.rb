Rails.application.routes.draw do
  devise_for :users

  root to: "items#index"

  resources :items do
    resources :questions, only: [ :create, :update, :destroy ]
  end

  resources :users, only: [ :show ]
end
