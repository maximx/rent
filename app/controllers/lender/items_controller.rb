class Lender::ItemsController < ApplicationController
  include UsersReviewsCount

  before_action :login_required
  load_and_authorize_resource :item, through: :current_user, only: [:index, :show]
  before_action :validates_profile, only: [:importer]
  before_action :load_categories_grouped_select, only: [:importer, :import]

  def index
    @items = @items.includes(:records, :lender)
                   .send(overlap_method, params[:started_at], params[:ended_at])
                   .search_by(params[:query])
                   .the_sort(params[:sort])
                   .page(params[:page])
  end

  def show
    @event_sources_path = calendar_item_path(@item, format: :json)
    @records = @item.records.includes(:borrower, :deliver, :item).recent.page(params[:page])
    @record_state_log = unless @records.empty?
                          @records.first.record_state_logs.build
                        else
                          RecordStateLog.new
                        end
  end

  def wish
    @items = current_user.collections
                         .includes(:pictures, :collectors, lender: [{ profile: :avatar}])
                         .the_sort(params[:sort])
                         .page(params[:page])
    find_users_reviews_count
    render 'items/index'
  end

  def importer
    authorize! :importer, Item
    @item = Item.new
    @error_messages = []
  end

  def import
    authorize! :import, Item
    @item = current_user.items.build importer_params

    if @item.valid_attributes?(importer_params.keys) and importer_params[:file].present?
      @error_messages = Item.import(current_user, importer_params)
      @error_messages.empty? ? redirect_to(lender_items_path) : render(:importer)
    else
      render :importer
    end
  end

  private
    def importer_params
      params.require(:item)
            .permit(:subcategory_id, :deliver_fee, :file, deliver_ids: [])
            .symbolize_keys
    end

    def overlap_method
      if Item.overlaps_values.include?(params[:overlaps])
        params[:overlaps]
      else
        Item.overlaps_types.first.second
      end
    end

    def load_categories_grouped_select
      @categories_grouped_select = Category.grouped_select
    end

    def validates_profile
      errors = current_user.profile.validates_basic_info
      unless errors.empty?
        redirect_to edit_user_path(current_user, redirect_url: importer_lender_items_path),
                    alert: t('activerecord.errors.models.profile.attributes.info.blank', attrs: errors.join('、'))
      end
    end
end
