class Settings::RentRecordsController < ApplicationController
  layout "application_aside"

  before_action :login_required

  def show
    @rent_records = current_user.rent_records.includes(:item).booking_order.page(params[:page])
  end

  def calendar
    @event_sources_path = calendar_settings_rent_records_path(format: :json, role: params[:role])
    rent_records_json = if params[:role] == "borrower"
                          current_user.rent_records.includes(:borrower)
                            .overlaps(params[:start], params[:end]).to_json
                        else
                          RentRecord.includes(:borrower).where(item_id: current_user.items)
                            .overlaps(params[:start], params[:end]).to_json
                        end

    respond_to do |format|
      format.html { render :calendar }
      format.json { render json: rent_records_json }
    end
  end

end
