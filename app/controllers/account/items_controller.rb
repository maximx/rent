class Account::ItemsController < ApplicationController
  before_action :login_required
  load_and_authorize_resource :customer, through: :current_user
  load_and_authorize_resource :item, through: :current_user
  before_action :load_customer_shopping_cart
  before_action ->{ set_title_meta_tag prefix: @customer.logo_name }

  def index
    @shopping_cart_items = @shopping_cart.shopping_cart_items.pluck(:item_id)
    @items = @items.includes(:records, :lender)
                   .search_by(params[:query])
                   .the_sort(params[:sort])
                   .page(params[:page])
  end
end
