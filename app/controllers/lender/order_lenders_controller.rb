class Lender::OrderLendersController < ApplicationController
  before_action :login_required
  load_and_authorize_resource :order
  load_and_authorize_resource :order_lender, through: :order

  def delivering
    @order_lender.delivery! current_user
    redirect_to :back
  end

  def renting
    @order_lender.rent! current_user, order_lender_log_params
    redirect_to :back
  end

  def returning
    @order_lender.return! current_user
    redirect_to :back
  end

  private
    def order_lender_log_params
      if params.has_key? :order_lender_log
        params.require(:order_lender_log).permit(:info, attachments: [])
      else
        {}
      end
    end
end
