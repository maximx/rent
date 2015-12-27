class ShoppingCartsController < ApplicationController
  before_action :login_required, only: [:update]
  before_action :load_shopping_cart

  def show
    @items = @shopping_cart.items.includes(:delivers)
  end

  def update
    #TODO: model shopping_cart attributes setting error
    #@shopping_cart.attributes = shopping_cart_params
    if @shopping_cart.valid?
      redirect_to shopping_carts_path
    else
      @items = @shopping_cart.items.includes(:delivers)
      render :show
    end
  end

  private
    def shopping_cart_params
      params.require(:shopping_cart).permit(
        :started_at, :ended_at,
        items_attributes: [:id, records_attributes: :deliver_id]
      ).deep_symbolize_keys
    end
end
