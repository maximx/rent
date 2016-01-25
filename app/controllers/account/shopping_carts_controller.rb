class Account::ShoppingCartsController < ApplicationController
  before_action :login_required
  load_and_authorize_resource :customer, through: :current_user
  before_action :load_customer_shopping_cart
  before_action :validates_borrower_info
  before_action :load_disabled_dates

  def show
    @lender_shopping_cart_items = @shopping_cart.shopping_cart_items
                                                .includes(:deliver, :lender, item: :delivers)
                                                .group_by(&:lender)
  end

  def update
    if @shopping_cart.update(shopping_cart_params)
      order = @shopping_cart.checkout
      redirect_to lender_order_path(order)
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
        errors = @customer.profile.validates_detail_info
        unless errors.empty?
          redirect_to(
            edit_account_customer_path(@customer, redirect_url: account_customer_shopping_carts_path(@customer)),
            alert: t('activerecord.errors.models.profile.attributes.info.blank', attrs: errors.join('、'))
          ) and yield
        end
      end
    end

    def borrower_info_needed?
      return true if current_user.borrower_info_provide
      @shopping_cart.shopping_cart_items.each do |shopping_cart_item|
        return true if shopping_cart_item.deliver.present? and shopping_cart_item.deliver.address_needed?
      end
      return false
    end
end
