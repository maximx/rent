Rails.application.routes.draw do
  root to: "pages#index"

  get "/about", to: "pages#about"
  get "/terms", to: "pages#terms"
  get "/privacy", to: "pages#privacy"
  get "/contact", to: "pages#contact"

  devise_for :users

  resources :tours, only: [ :index ] do
    collection do
      get :state, :calendar, :contract, :dashboard
    end
  end

  resources :categories, only: [ :show ]
  resources :subcategories, only: [ :show ]

  resources :items do
    resources :records, except: [ :edit, :update, :destroy ] do
      resources :reviews, only: [ :new, :create ]

      member do
        put :remitting, :delivering, :renting, :returning
        post :ask_for_review
        delete :withdrawing
      end
    end

    get :search, on: :collection
    member do
      get :calendar
      post :collect
      patch :open, :close
      delete :uncollect
    end
  end

  resources :users, only: [ :show, :edit, :update ] do
    member do
      get :reviews, :lender_reviews, :borrower_reviews, :items
      put :follow
      patch :avatar
      delete :unfollow
    end
  end

  resources :attachments, only: [ :destroy ] do
    get :download, on: :member
  end

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

  # TODO issue 122
  namespace :account do
    resource :settings, only: [ :show, :update ] do
      get :preferences, :phone_confirmation
      post :phone_confirmed, :upload
      patch :save
    end

    resources :stores, param: :account do
      resources :items do
        resources :records
      end
    end

    resources :customers
    #resources :records
  end

  namespace :dashboard do
    resources :customers, except: [ :destroy ]

    resources :items, only: [ :index, :show ] do
      resources :records, only: [ :new, :create ]
      get :records, on: :member
      get :wish, :calendar, on: :collection
    end

    resources :records, only: [ :index ] do
      get :calendar, on: :collection
    end
  end
end
