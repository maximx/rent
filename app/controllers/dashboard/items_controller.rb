class Dashboard::ItemsController < ApplicationController
  include UsersReviewsCount
  include SortPaginate

  before_action :login_required
  before_action :find_items, only: [ :index ]

  def index
    @records_count = @items.joins(:records).group(:item_id, 'records.aasm_state').count
    @records_count.default = 0
  end

  def wish
    @items = current_user.collections.includes(:pictures, :city, :collectors, lender: [{ profile: :avatar}])
    sort_and_paginate_items
    find_users_reviews_count
    render 'items/index'
  end

  def calendar
    @event_sources_path = calendar_dashboard_items_path(format: :json)
    records_json = current_user.lend_records
                               .includes(:borrower, :item)
                               .overlaps(params[:start], params[:end])
                               .to_json
    respond_to do |format|
      format.html
      format.json { render json: records_json }
    end
  end

  private

    def find_items
      @items = current_user.items.includes(:records).send(overlap_method, params[:started_at], params[:ended_at])
                .search_by(params[:query]).page(params[:page])
    end

    def overlap_method
      if Item.overlaps_values.include?(params[:overlaps])
        params[:overlaps]
      else
        Item.overlaps_types.first.second
      end
    end
end
