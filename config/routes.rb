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

  resources :profiles, only: [ :update ]

  namespace :settings do
    resource :account, only: [ :show, :edit, :update ]
    resources :items, only: [ :index, :show ] do
      resources :records, only: :index
    end
    resource :rent_records, only: [ :show ] do
      get :calendar, on: :member
    end
  end

  resources :categories, only: [ :show ]
  resources :subcategories, only: [ :show ]

  resources :conversations, only: [ :index, :show, :destroy ] do
    get :unread, on: :collection
    member do
      put :mark_as_read
      post :reply
    end
  end
  resources :messages, only: [ :create ]
end
