class Dashboard::RentRecordsController < ApplicationController
  before_action :login_required

  def show
    @rent_records = current_user.borrow_records.includes(:item).rencent.page(params[:page])
    @rent_record_state_log = unless @rent_records.empty?
                               @rent_records.first.rent_record_state_logs.build
                             else
                               RentRecordStateLog.new
                             end
  end

  def calendar
    @event_sources_path = calendar_dashboard_rent_records_path(format: :json, role: params[:role])
    rent_records_json = if params[:role] == "borrower"
                          current_user.borrow_records.includes(:borrower)
                            .overlaps(params[:start], params[:end]).to_json
                        else
                          current_user.lend_records.includes(:borrower)
                            .overlaps(params[:start], params[:end]).to_json
                        end

    respond_to do |format|
      format.html { render :calendar }
      format.json { render json: rent_records_json }
    end
  end
end
