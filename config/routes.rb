Rails.application.routes.draw do
  root to: "items#index"
  get "/search", to: "items#search"

  devise_for :users

  resources :items do
    resources :questions, only: [ :create, :update, :destroy ]
    resources :pictures, only: [ :destroy ]

    member do
      get :calendar
      get :questions
    end

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
      get :items
      get :lender_reviews
      get :borrower_reviews
      get :following
      get :items_collect

      post :follow
      delete :unfollow
    end
  end

  resources :profiles, only: [ :create, :update ]

  namespace :settings do
    resource :account, only: [ :show, :edit, :update ]
    resource :rent_records, only: [ :show ] do
      get :calendar, on: :member
    end

    resource :items, only: [ :show ]
  end

  resources :categories, only: [ :show ]
  resources :subcategories, only: [ :show ]

  resources :pages, only:[ :index ] if Rails.env.development?

end
