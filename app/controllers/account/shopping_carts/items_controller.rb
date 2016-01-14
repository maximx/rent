class Account::ShoppingCarts::ItemsController < ApplicationController
  before_action :login_required
  load_and_authorize_resource :customer, through: :current_user
  load_and_authorize_resource :item, through: :current_user
  skip_authorize_resource :item
  before_action :load_customer_shopping_cart

  def add
    @shopping_cart.add @item
    redirect_to account_customer_items_path(@customer)
  end

  def remove
    @shopping_cart.remove @item
    redirect_to account_customer_items_path(@customer)
  end
end
