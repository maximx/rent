Rails.application.routes.draw do
  root to: "pages#index"

  get "/about",   to: "pages#about"
  get "/terms",   to: "pages#terms"
  get "/privacy", to: "pages#privacy"
  get "/contact", to: "pages#contact"

  devise_for :users, controllers: {omniauth_callbacks: "users/omniauth_callbacks"}

  resources :tours, only: [:index] do
    collection do
      get :calendar, :import, :state, :contract, :customer
    end
  end

  resources :categories, only: [:show]
  resources :subcategories, only: [:show]

  resources :items do
    resources :records, except: [:edit, :update, :destroy]

    get :search, on: :collection
    member do
      get    :calendar
      post   :collect
      delete :uncollect
      patch  :open, :close
    end
  end

  resource :shopping_carts, only: [:show, :update]
  namespace :shopping_carts do
    resources :items, only:[] do
      member do
        post   :add
        delete :remove
      end
    end
  end

  resources :users, param: :account, only: [:show, :edit, :update] do
    member do
      get    :reviews, :lender_reviews, :borrower_reviews, :items
      put    :follow
      patch  :avatar, :save
      delete :unfollow
    end

    resources :subcategories, only: [] do
      resources :vectors, only: [:index]
    end
  end

  resources :attachments, only: [:destroy] do
    get :download, on: :member
  end

  resources :notifications, only: [:index, :show] do
    put :mark_as_read, on: :member
  end

  namespace :account do
    resource :settings, only: [:show, :update] do
      get   :preferences, :phone_confirmation, :lender, :become
      post  :phone_confirmed, :upload
      patch :save
    end

    resources :categories, only: [:index]
    resources :subcategories, only: [:index] do
      resources :vectors, only: [:create, :destroy, :index]
    end
    resources :vectors, only: [] do
      resources :selections, only: [:create, :destroy]
    end

    resources :customers, except: [:destroy] do
      resources :items, only: [:index]
      resource :shopping_carts, only: [:show, :update]

      scope module: :shopping_carts do
        resources :items, only:[] do
          member do
            post   :add
            delete :remove
          end
        end
      end
    end
  end

  namespace :lender do
    resources :items, only: [:index, :show] do
      collection do
        get  :wish, :importer
        post :import
      end
    end

    resources :orders, only: [:index, :show] do
      resources :order_lenders, only: [] do
        put :delivering, :renting, :returning
      end

      get :calendar, on: :collection
    end
  end

  namespace :borrower do
    resources :orders, only: [:index, :show] do
      resources :order_lenders, only: [] do
        put    :remitting
        delete :withdrawing
      end

      get :calendar, on: :collection
    end
  end
end
