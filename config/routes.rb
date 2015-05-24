Rails.application.routes.draw do
  devise_for :users

  root to: "items#index"

  resources :items do
    resources :questions, only: [ :create, :update, :destroy ]
    resources :rent_records
  end

  resources :users, only: [ :show ] do
    member do
      post :follow, :unfollow
    end
  end
end
