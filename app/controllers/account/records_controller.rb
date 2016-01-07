class Account::RecordsController < ApplicationController
  before_action :login_required

  def index
    @records = current_user.records
                           .includes(:borrower, :deliver, [item: [lender: [profile: :avatar]]])
                           .recent
                           .page(params[:page])
    @record_state_log = unless @records.empty?
                          @records.first.record_state_logs.build
                        else
                          RecordStateLog.new
                        end
  end

  def calendar
    @event_sources_path = calendar_account_records_path(format: :json)

    respond_to do |format|
      format.html
      format.json {
        records_json = current_user.orders
                                   .includes(borrower: :profile)
                                   .overlaps(params[:start], params[:end])
                                   .to_json
        render json: records_json
      }
    end
  end
end
