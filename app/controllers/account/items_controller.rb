class Account::ItemsController < ApplicationController
  before_action :login_required
  load_and_authorize_resource :customer, through: :current_user
  load_and_authorize_resource :item, through: :current_user
  skip_authorize_resource :item, only: [:add, :remove]
  before_action :load_customer_shopping_cart, only: [:add, :remove]

  def index
    @items = @items.includes(:records, :lender)
                   .search_by(params[:query])
                   .the_sort(params[:sort])
                   .page(params[:page])
  end

  def add
    @shopping_cart.add @item
    redirect_to account_customer_items_path(@customer)
  end

  def remove
    @shopping_cart.remove @item
    redirect_to account_customer_items_path(@customer)
  end

  private
    def load_customer_shopping_cart
      @shopping_cart = @customer.shopping_cart
      @shopping_cart = @customer.create_shopping_cart unless @shopping_cart.present?
    end
end
