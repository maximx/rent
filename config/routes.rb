Rails.application.routes.draw do
  devise_for :users

  root to: "pages#index"

  resources :items do
    resources :questions, only: [ :create, :update, :destroy ]
  end
end
