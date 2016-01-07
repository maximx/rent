class ShoppingCartsController < ApplicationController
  before_action :login_required
  before_action :load_shopping_cart
  before_action :load_disabled_dates

  def show
    @shopping_cart_items = @shopping_cart.shopping_cart_items.includes(:deliver, item: :delivers)
  end

  def update
    @shopping_cart.user = current_user
    if @shopping_cart.update(shopping_cart_params)
      order = @shopping_cart.checkout
      order.records.group_by(&:lender).each do |lender, records|
        lender.notify t('controller.shopping_carts.update.notify_lender',
                        name: current_user.logo_name,
                        period: view_context.render_datetime_period(order),
                        count: records.count),
                      lender_order_url(order)
      end
      redirect_to borrower_order_path(order)
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
