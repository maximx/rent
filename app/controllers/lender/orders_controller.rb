class Lender::OrdersController < ApplicationController
  before_action :login_required
  load_and_authorize_resource only: [:show]

  def index
    @orders = current_user.lend_orders.recent.page(params[:page])
    @orders_price = current_user.lend_records
                                .where(order_id: @orders.pluck(:order_id))
                                .group(:order_id)
                                .sum(:price)
  end

  def show
    @records = @order.records_of(current_user)
    @records = @records.includes(:borrower, :deliver, [item: [lender: [profile: :avatar]]])
                       .recent
                       .page(params[:page])
    @record_state_log = unless @records.empty?
                          @records.first.record_state_logs.build
                        else
                          RecordStateLog.new
                        end
  end
end
