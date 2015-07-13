class Settings::RentRecordsController < ApplicationController
  layout "application_aside"

  before_action :login_required

  def index
    @rent_records = current_user.rent_records.reverse_order
  end
end
