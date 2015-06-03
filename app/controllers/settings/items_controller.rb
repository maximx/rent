class Settings::ItemsController < ApplicationController
  before_action :login_required

  def index
    @items = current_user.items

    @rent_records_count = @items.joins(:rent_records).group(:item_id, :aasm_state).count
    @rent_records_count.default = 0
  end
end
