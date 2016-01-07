class Borrower::OrdersController < ApplicationController
  before_action :login_required
  load_and_authorize_resource through: :current_user

  def index
    @orders = @orders.recent.page(params[:page])
  end

  def show
    @records = @order.records
    unless request.xhr?
      @records = @records.includes(:borrower, :deliver, [item: [lender: [profile: :avatar]]])
                         .recent
                         .page(params[:page])
      @record_state_log = unless @records.empty?
                            @records.first.record_state_logs.build
                          else
                            RecordStateLog.new
                          end
    else
      @records = @records.includes(:item)
      @detail_url = borrower_order_path(@order)
      render 'lender/orders/show_xhr'
    end
  end

  def calendar
    @event_sources_path = calendar_borrower_orders_path(format: :json)

    respond_to do |format|
      format.html
      format.json {
        records_json = current_user.orders
                                   .includes(borrower: :profile)
                                   .overlaps(params[:start], params[:end])
                                   .to_json(role: 'borrower')
        render json: records_json
      }
    end
  end
end
