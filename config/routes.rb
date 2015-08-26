Rails.application.routes.draw do
  root to: "pages#index"
  get "/about", to: "pages#about"
  get "/terms", to: "pages#terms"
  get "/privacy", to: "pages#privacy"

  devise_for :users

  resources :items do
    resources :questions, only: [ :create, :update, :destroy ]
    resources :pictures, only: [ :destroy ]

    resources :rent_records, except: [ :destroy ] do
      resources :reviews, only: [ :create ]

      member do
        get :review
        put :remitting
        put :delivering
        put :renting
        put :returning
        delete :withdrawing
        post :ask_for_review
      end
    end

    get :search, on: :collection
    member do
      get :reviews
      post :collect
      delete :uncollect
      get :calendar
    end
  end

  resources :users, only: [ :show ] do
    member do
      get :lender_reviews
      get :borrower_reviews
      get :wish

      post :follow
      delete :unfollow
    end
  end

  resources :profiles, only: [ :create, :update ]

  namespace :settings do
    resource :account, only: [ :show, :edit, :update ]
    resource :items, only: [ :show ]
    resource :rent_records, only: [ :show ] do
      get :calendar, on: :member
    end
  end

  resources :categories, only: [ :show ]
  resources :subcategories, only: [ :show ]
end
