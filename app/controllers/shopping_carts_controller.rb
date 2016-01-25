class ShoppingCartsController < ApplicationController
  before_action :login_required
  before_action :load_shopping_cart
  before_action :validates_borrower_info
  before_action :load_disabled_dates

  def show
    @lender_shopping_cart_items = @shopping_cart.shopping_cart_items
                                                .includes(:deliver, :lender, item: :delivers)
                                                .group_by(&:lender)
  end

  def update
    @shopping_cart.user = current_user
    if @shopping_cart.update(shopping_cart_params)
      order = @shopping_cart.checkout
      order.records.group_by(&:lender).each do |lender, records|
        OrderMailer.send_payment_message(order, lender.profile, records).deliver_now

        lender.notify t('controller.shopping_carts.update.notify_lender',
                        name: current_user.logo_name,
                        period: view_context.render_datetime_period(order),
                        count: records.count),
                      lender_order_url(order)
      end
      redirect_to borrower_order_path(order)
    else
      validates_borrower_info { return }
      @lender_shopping_cart_items = @shopping_cart.shopping_cart_items.group_by(&:lender)
      render :show
    end
  end

  private
    def shopping_cart_params
      params.require(:shopping_cart).permit(
        :started_at, :ended_at,
        shopping_cart_items_attributes: [:id, :deliver_id, :send_period]
      ).deep_symbolize_keys
    end

    def load_disabled_dates
      @disabled_dates = @shopping_cart.booked_dates
    end

    def validates_borrower_info
      if borrower_info_needed?
        errors = current_user.profile.validates_detail_info
        unless errors.empty?
          redirect_to(
            edit_user_path(current_user, redirect_url: shopping_carts_path),
            alert: t('activerecord.errors.models.profile.attributes.info.blank', attrs: errors.join('、'))
          ) and yield
        end
      end
    end

    def borrower_info_needed?
      return true if @shopping_cart.lender_request_borrower_info_needed?
      @shopping_cart.shopping_cart_items.each do |shopping_cart_item|
        return true if shopping_cart_item.deliver.present? and shopping_cart_item.deliver.address_needed?
      end
      return false
    end
end
