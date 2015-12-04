class ItemsController < ApplicationController
  include FileAttrSetter
  include UsersReviewsCount
  include SortPaginate

  before_action :login_required, except: [ :index, :show, :search, :questions ]
  before_action :find_lender_item, only: [ :edit, :update, :close, :open, :destroy ]
  before_action :validates_profile, only: [ :new, :create, :edit, :update ]
  before_action :find_item, only: [ :show, :collect, :uncollect, :calendar, :questions ]
  before_action :find_navbar_categories, except: [ :collect, :uncollect, :calendar ]
  before_action :set_item_meta_tags, :build_record, :find_item_disabled_dates, only: [ :show, :questions ]
  before_action :set_pictures_attr, only: [ :create, :update ]

  def index
    @items = Item.includes(:pictures, :city, :collectors, lender: [{ profile: :avatar}])
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
      redirect_with_message item_path(@item), notice: "#{@item.name}修改成功。" unless remotipart_submitted?
    else
      unless remotipart_submitted?
        flash[:alert] = '請檢查紅字錯誤欄位'
        render :edit
      end
    end
  end

  def open
    if @item.closed?
      @item.open!
      redirect_with_message dashboard_items_path, notice: t('controller.item.open.success', name: @item.name)
    else
      redirect_with_message dashboard_items_path, alert: t('common.error')
    end
  end

  def close
    if @item.opening?
      @item.close!
      redirect_with_message dashboard_items_path, notice: t('controller.item.close.success', name: @item.name)
    else
      redirect_with_message dashboard_items_path, alert: t('common.error')
    end
  end

  def destroy
    if @item.records.empty?
      @item.destroy
      redirect_with_message dashboard_items_path, notice: t('controller.item.destroy.success', name: @item.name)
    else
      redirect_with_message dashboard_items_path, alert: t('controller.item.destroy.fail', name: @item.name)
    end
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
    @items = Item.includes(:pictures, :city, :collectors, lender: [{ profile: :avatar}])
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
    records_json = @item.records.actived.includes(:borrower)
      .overlaps(params[:start], params[:end]).to_json

    respond_to do |format|
      format.json { render json: records_json}
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

    def build_record
      @record = @item.records.build
    end

    def validates_profile
      result = current_user.profile.validates

      unless result[:errors].empty?
        redirect_with_message(edit_user_path(current_user), notice: result[:message])
      end
    end
end
