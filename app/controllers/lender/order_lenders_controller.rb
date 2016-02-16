class Lender::OrderLendersController < ApplicationController
  before_action :login_required
  load_and_authorize_resource :order
  load_and_authorize_resource :order_lender, through: :order

  def delivering
    @order_lender.delivery!
    redirect_to :back
  end

  def renting
    @order_lender.rent!
    redirect_to :back
  end

  def returning
    @order_lender.return!
    redirect_to :back
  end
end
