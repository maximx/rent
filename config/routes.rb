Rails.application.routes.draw do
  devise_for :users

  root to: "items#index"

  resources :items do
    resources :questions, only: [ :create, :update, :destroy ]
    resources :rent_records

    member do
      post :collect
      delete :uncollect
    end
  end

  resources :users, only: [ :show ] do
    member do
      post :follow
      delete :unfollow
    end
  end
end
