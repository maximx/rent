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
        put :remitting, :delivering, :renting, :returning
        post :ask_for_review
        delete :withdrawing
      end
    end

    get :search, on: :collection
    member do
      get :questions, :calendar
      post :collect
      delete :uncollect
    end
  end

  resources :users, only: [ :show ] do
    member do
      get :reviews, :lender_reviews, :borrower_reviews, :items
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
      get :images, :phone_confirmation
      post :phone_confirmed, :upload
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
