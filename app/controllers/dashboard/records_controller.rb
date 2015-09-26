class Dashboard::RecordsController < ApplicationController
  before_action :login_required
  before_action :find_item

  def index
    @rent_records = @item.rent_records.actived.rencent.page(params[:page])
  end

  private

    def find_item
      @item = Item.find(params[:item_id])
    end
end