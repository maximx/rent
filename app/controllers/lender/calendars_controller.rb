class Lender::CalendarsController < ApplicationController
  before_action :login_required

  def show
    @event_sources_path = lender_calendar_path(format: :json)

    respond_to do |format|
      format.html
      format.json {
        records_json = current_user.lend_orders
                                   .includes(borrower: :profile)
                                   .overlaps(params[:start], params[:end])
                                   .uniq
                                   .to_json
        render json: records_json
      }
    end
  end
end
