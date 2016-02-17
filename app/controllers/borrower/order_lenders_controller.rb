class Borrower::OrderLendersController < ApplicationController
  before_action :login_required
  load_and_authorize_resource :order
  load_and_authorize_resource :order_lender, through: :order

  def remitting
    if @order_lender.remit!(current_user, order_lender_log_params)
      redirect_to borrower_order_path @order
    else
      @order_lenders    = @order.order_lenders.includes(lender: :profile, records: :item)
      @order_lender_log = @order_lender.order_lender_logs.last
      flash.now[:alert] = t('controller.borrower/order_lenders.remitting.fail')
      render 'borrower/orders/show'
    end
  end

  def withdrawing
    @order_lender.withdraw! current_user
    redirect_to :back
  end

  private
    def order_lender_log_params
      if params.has_key? :order_lender_log
        params.require(:order_lender_log).permit(:info)
      else
        {}
      end
    end
end
