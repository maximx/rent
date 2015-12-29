class Account::OrdersController < ApplicationController
  before_action :login_required
  load_and_authorize_resource

  def index
  end

  def show
    @records = @order.records
                     .includes(:borrower, :deliver, [ item: [ lender: [profile: :avatar] ] ])
                     .rencent.page(params[:page])
    @record_state_log = unless @records.empty?
                          @records.first.record_state_logs.build
                        else
                          RecordStateLog.new
                        end
    render 'account/records/index'
  end
end