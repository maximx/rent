class ItemsController < ApplicationController
  include FileAttrSetter
  include UsersReviewsCount
  include SortPaginate

  before_action :login_required, except: [ :index, :show, :search, :questions ]
  before_action :validates_profile, only: [ :new, :create, :edit, :update ]
  before_action :find_lender_item, only: [ :edit, :update, :destroy ]
  before_action :find_item, only: [ :show, :collect, :uncollect, :calendar, :questions ]
  before_action :find_navbar_categories, except: [ :collect, :uncollect, :calendar ]
  before_action :set_item_meta_tags, :build_rent_record, :find_item_disabled_dates, only: [ :show, :questions ]
  before_action :set_pictures_attrs, only: [ :create, :update ]

  def index
    @items = Item.includes(:pictures)
    sort_and_paginate_items
    find_users_reviews_count
    meta_pagination_links @items
  end

  def show
    set_maps_marker @item
    @reviews = @item.reviews.where(user_id: @item.lender).page(params[:page])
  end

  def questions
    set_maps_marker @item
    @question = @item.questions.build
  end

  def new
    @item = Item.new
    @item.pictures.build
  end

  def create
    @item = current_user.items.build(item_params)

    if @item.save
      redirect_with_message item_path(@item), notice: "#{@item.name}新增成功。"
    else
      flash[:alert] = '請檢查紅字錯誤欄位'
      render :new
    end
  end

  def edit
  end

  def update
    if @item.update(item_params)
      redirect_with_message item_path(@item), notice: "#{@item.name}修改成功。"
      redirect_to item_path(@item)
    else
      flash[:alert] = '請檢查紅字錯誤欄位'
      render :edit
    end
  end

  def destroy
    @item.destroy
    redirect_to dashboard_items_path
  end

  def collect
    unless current_user.is_collected?(@item)
      current_user.collect!(@item)
      result = {
        status: 'ok',
        href: uncollect_item_path(@item, format: :json),
        title: '取消收藏',
        method: 'delete',
        class: 'btn-danger'
      }
    end

    respond_to do |format|
      format.html { redirect_to item_path(@item) }
      format.json { render json: result }
    end
  end

  def uncollect
    if current_user.is_collected?(@item)
      current_user.uncollect!(@item)
      result = {
        status: 'ok',
        href: collect_item_path(@item, format: :json),
        title: '收藏',
        method: 'post',
        class: 'btn-default'
      }
    end

    respond_to do |format|
      format.html { redirect_to item_path(@item) }
      format.json { render json: result }
    end
  end

  def search
    @items = Item.includes(:pictures)
                 .record_not_overlaps(params[:started_at], params[:ended_at])
                 .price_range(params[:price_min], params[:price_max])
                 .search_by(params[:query])
                 .city_at(params[:city])
    @items = @items.where(user_id: params[:user_id]) if params.has_key?(:user_id)
    sort_and_paginate_items
    find_users_reviews_count
    render :index
  end

  def calendar
    @event_sources_path = calendar_item_path(@item, format: :json)
    rent_records_json = @item.rent_records.actived.includes(:borrower)
      .overlaps(params[:start], params[:end]).to_json

    respond_to do |format|
      format.json { render json: rent_records_json}
    end
  end

  private

    def item_params
      params.require(:item).permit(
        :name, :price, :minimum_period, :address,
        :deposit, :description, :subcategory_id,
        :deliver_fee, deliver_ids: [ ],
        pictures_attributes: [ :public_id, :file_cached ]
      )
    end

    def find_lender_item
      @item = current_user.items.find(params[:id])
    end

    def find_item
      @item = Item.find(params[:id])
    end

    def set_item_meta_tags
      set_meta_tags(
        title: @item.name,
        keywords: @item.meta_keywords,
        description: @item.meta_description,
        canonical: item_url(@item),
        og: {
          title: @item.name,
          description: @item.meta_description,
          url: item_url(@item),
          image: @item.pictures_urls
        }
      )
    end

    def find_item_disabled_dates
      @disabled_dates = @item.booked_dates
    end

    def build_rent_record
      @rent_record = @item.rent_records.build
    end

    def validates_profile
      result = current_user.profile.validates

      unless result[:errors].empty?
        redirect_with_message(settings_account_path, notice: result[:message])
      end
    end
end
