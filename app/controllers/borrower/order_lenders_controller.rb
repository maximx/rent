class Borrower::OrderLendersController < ApplicationController
  before_action :login_required
  load_and_authorize_resource :order
  load_and_authorize_resource :order_lender, through: :order

  def remitting
    @order_lender.remit!
    redirect_to :back
  end

  def withdrawing
    @order_lender.withdraw!
    redirect_to :back
  end
end
