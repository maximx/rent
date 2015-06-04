Rails.application.routes.draw do
  root to: "items#index"
  get "/search", to: "items#search"
  get "/settings", to: "settings/items#index"

  devise_for :users

  resources :items do
    resources :questions, only: [ :create, :update, :destroy ]

    resources :rent_records do
      resources :reviews, only: [ :create ]
      get :review, on: :member
    end

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

  namespace :settings do
    resources :account, only: [ :index ]
    resources :items, only: [ :index ]
    resources :requirements, only: [ :index ]
  end

  resources :categories, only: [ :show ]
  resources :subcategories, only: [ :show ]
end
