Rails.application.routes.draw do
  root to: "pages#index"
  get "/about", to: "pages#about"
  get "/terms", to: "pages#terms"
  get "/privacy", to: "pages#privacy"
  get "/contact", to: "pages#contact"

  devise_for :users

  resources :items do
    resources :questions, only: [ :create, :update, :destroy ]
    resources :pictures, only: [ :destroy ]

    resources :rent_records, except: [ :edit, :update, :destroy ] do
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
      get :questions
      post :collect
      delete :uncollect
      get :calendar
    end
  end

  resources :users, only: [ :show ] do
    member do
      get :reviews
      get :lender_reviews
      get :borrower_reviews

      put :follow
      delete :unfollow
    end
  end

  resources :profiles, only: [ :update ] do
    put :update_bank_info, on: :member
  end
  resources :pictures, only: [] do
    get :download, on: :member
  end

  namespace :settings do
    resource :account, only: [ :show, :edit, :update ] do
      get :phone_confirmation, on: :collection
      post :phone_confirmed, on: :collection
    end
  end

  namespace :dashboard do
    resources :items, only: [ :index, :show ] do
      get :wish, on: :collection
      get :rent_records, on: :member
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
  resources :notifications, only: [ :index, :show ] do
    put :mark_as_read, on: :member
  end
  resources :messages, only: [ :create ]
end
