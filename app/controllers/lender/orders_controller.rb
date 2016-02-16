class Lender::OrdersController < ApplicationController
  before_action :login_required
  load_and_authorize_resource only: [:show]
  before_action ->{ set_title_meta_tag namespace: true }, except: [:show]
  before_action ->{ set_title_meta_tag namespace: true, suffix: "##{@order.id}" }, only: [:show]

  def index
    @orders = current_user.lend_orders.recent.page(params[:page])
    @orders_total_price = current_user.lend_records
                                      .where(order_id: @orders.pluck(:order_id))
                                      .group(:order_id)
                                      .sum('records.price + records.item_deposit + records.deliver_fee')
  end

  def show
    @order_lenders = @order.order_lenders.where(lender: current_user)

    unless request.xhr?
      @order_lenders = @order_lenders.includes(lender: :profile, records: :item)
    else
      @records = @order_lenders.first.records
      @detail_url = lender_order_path(@order)
      render :show_xhr
    end
  end

  def calendar
    @event_sources_path = calendar_lender_orders_path(format: :json)

    respond_to do |format|
      format.html
      format.json {
        records_json = current_user.lend_orders
                                   .includes(borrower: :profile)
                                   .overlaps(params[:start], params[:end])
                                   .uniq
                                   .to_json(role: 'lender')
        render json: records_json
      }
    end
  end
end
