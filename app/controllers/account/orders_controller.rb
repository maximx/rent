class Account::OrdersController < ApplicationController
  before_action :login_required
  load_and_authorize_resource through: :current_user, only: [:index]
  load_and_authorize_resource only: [:show]

  def index
    @orders = @orders.recent.page(params[:page])
  end

  def show
    @records = if @order.borrower?(current_user)
                 @order.records
               else
                 @order.records_of(current_user)
               end
    @records = @records.includes(:borrower, :deliver, [item: [lender: [profile: :avatar]]])
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
