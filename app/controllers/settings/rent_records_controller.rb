class Settings::RentRecordsController < ApplicationController
  before_action :login_required

  def index
    @rent_records = current_user.rent_records.reverse_order
  end
end
