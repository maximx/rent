class Account::ItemsController < ApplicationController
  include UsersReviewsCount

  before_action :login_required
  load_and_authorize_resource :item, through: :current_user, only: [ :index, :show ]

  def index
    @items = @items.includes(:records)
                   .send(overlap_method, params[:started_at], params[:ended_at])
                   .search_by(params[:query])
                   .page(params[:page])
    @records_count = @items.joins(:records).group(:item_id, 'records.aasm_state').count
    @records_count.default = 0
  end

  def show
    @event_sources_path = calendar_item_path(@item, format: :json)
    @records = @item.records.includes(:borrower, :deliver, :item).rencent.page(params[:page])
    @record_state_log = unless @records.empty?
                          @records.first.record_state_logs.build
                        else
                          RecordStateLog.new
                        end
  end

  def wish
    @items = current_user.collections
                         .includes(:pictures, :city, :collectors, lender: [{ profile: :avatar}])
                         .the_sort(params[:sort])
                         .page(params[:page])
    find_users_reviews_count
    render 'items/index'
  end

  def calendar
    @event_sources_path = calendar_account_items_path(format: :json)
    records_json = current_user.lend_records
                               .includes(:borrower, :item)
                               .overlaps(params[:start], params[:end])
                               .to_json
    respond_to do |format|
      format.html
      format.json { render json: records_json }
    end
  end

  def importer
    @categories_grouped_select = Category.grouped_select
    @delivers = Deliver.all
  end

  def import
    #TODO:validate impoters all present
    if importer_params.present? and importer_params[:file].present?
      Item.import(current_user, importer_params)
      redirect_to account_items_path
    else
      redirect_to importer_account_items_path
    end
  end

  private
    def importer_params
      params.require(:importer)
            .permit(:subcategory_id, :deliver_fee, :address, :file, deliver_ids: [])
            .symbolize_keys
    end

    def overlap_method
      if Item.overlaps_values.include?(params[:overlaps])
        params[:overlaps]
      else
        Item.overlaps_types.first.second
      end
    end
end
