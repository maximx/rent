class Dashboard::ItemsController < ApplicationController
  include UsersReviewsCount
  include SortPaginate

  before_action :login_required
  before_action :find_items, only: [ :index ]

  def index
    @rent_records_count = @items.joins(:rent_records).group(:item_id, :aasm_state).count
    @rent_records_count.default = 0
  end

  def wish
    @items = current_user.collections.page(params[:page])
    sort_and_paginate_items
    find_users_reviews_count
    render 'items/index'
  end

  def rent_records
    @item = Item.find params[:id]
    @rent_records = @item.rent_records.actived.rencent.page(params[:page])
    @rent_record_state_log = unless @rent_records.empty?
                               @rent_records.first.rent_record_state_logs.build
                             else
                               RentRecordStateLog.new
                             end
  end

  private

    def find_items
      @items = current_user.items.send(overlap_method, params[:started_at], params[:ended_at])
                .search_by(params[:query])
    end

    def overlap_method
      if Item.overlaps_values.include?(params[:overlaps])
        params[:overlaps]
      else
        Item.overlaps_types.first.second
      end
    end
end
