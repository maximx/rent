class Account::OrdersController < ApplicationController
  before_action :login_required
  load_and_authorize_resource :order, through: :current_user

  def index
    @orders = @orders.recent.page(params[:page])
  end

  def show
    @records = @order.records
                     .includes(:borrower, :deliver, [ item: [ lender: [profile: :avatar] ] ])
                     .recent
                     .page(params[:page])
    @record_state_log = unless @records.empty?
                          @records.first.record_state_logs.build
                        else
                          RecordStateLog.new
                        end
    render 'account/records/index'
  end
end
