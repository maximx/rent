Rails.application.routes.draw do
  root to: "items#index"
  get "/search", to: "items#search"

  devise_for :users

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

  resources :pages, only:[ :index ]
  resources :requirements
end
