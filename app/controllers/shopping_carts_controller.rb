class ShoppingCartsController < ApplicationController
  before_action :login_required, only: [:update]
  before_action :load_shopping_cart
  before_action :load_disabled_dates

  def show
    @shopping_cart_items = @shopping_cart.shopping_cart_items.includes(:deliver, item: :delivers)
  end

  def update
    @shopping_cart.user = current_user
    if @shopping_cart.update(shopping_cart_params)
      @shopping_cart.create_order
      redirect_to shopping_carts_path
    else
      @shopping_cart_items = @shopping_cart.shopping_cart_items
      render :show
    end
  end

  private
    def shopping_cart_params
      params.require(:shopping_cart).permit(
        :started_at, :ended_at,
        shopping_cart_items_attributes: [:id, :deliver_id]
      ).deep_symbolize_keys
    end

    def load_disabled_dates
      @disabled_dates = @shopping_cart.booked_dates
    end
end
