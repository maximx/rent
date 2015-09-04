class Settings::RecordsController < ApplicationController
  layout "application_aside"

  before_action :login_required
  before_action :find_item

  def index
    @rent_records = @item.rent_records.actived.rencent.page(params[:page])
    render 'rent_records/index'
  end

  private

    def find_item
      @item = Item.find(params[:item_id])
    end
end
