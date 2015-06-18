Rails.application.routes.draw do
  root to: "items#index"
  get "/search", to: "items#search"
  get "/settings", to: "settings/accounts#show"

  devise_for :users

  resources :items do
    resources :questions, only: [ :create, :update, :destroy ]
    resources :pictures, only: [ :destroy ]

    resources :rent_records do
      resources :reviews, only: [ :create ]

      member do
        get :review
        put :renting
        put :returning
        delete :withdrawing
        post :ask_for_review
      end
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

  resources :profiles, only: [ :create, :update ]

  resources :pages, only:[ :index ]

  namespace :settings do
    resource :account, only: [ :show, :edit, :update ]
    resources :items, only: [ :index ]
    resources :rent_records, only: [ :index ]
  end

  resources :categories, only: [ :show ]
  resources :subcategories, only: [ :show ]
end
