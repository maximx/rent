class Borrower::OrdersController < ApplicationController
  before_action :login_required
  load_and_authorize_resource through: :current_user
  before_action ->{ set_title_meta_tag namespace: true }, except: [:show]
  before_action ->{ set_title_meta_tag namespace: true, suffix: "##{@order.id}" }, only: [:show]

  def index
    @orders = @orders.recent.page(params[:page])
  end

  def show
    unless request.xhr?
      @order_lenders = @order.order_lenders.includes(lender: :profile, records: :item)
      @order_lender_log = @order_lenders.first.order_lender_logs.build
    else
      @records = @order.records.includes(:item)
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
