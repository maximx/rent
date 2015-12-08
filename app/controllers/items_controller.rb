class ItemsController < ApplicationController
  include UsersReviewsCount
  include SortPaginate

  before_action :login_required, except: [ :index, :show, :search, :questions ]
  before_action :validates_profile, only: [ :new, :create ]
  load_and_authorize_resource except: [ :create, :search ]
  before_action :find_navbar_categories, except: [ :collect, :uncollect, :calendar ]
  before_action :set_item_meta_tags, :build_record, :find_item_disabled_dates, only: [ :show, :questions ]

  def index
    @items = Item.includes(:pictures, :city, :collectors, lender: [{ profile: :avatar}]).opening
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
    @item.set_address current_user
    @item.pictures.build
  end

  def create
    pictures = item_params.delete :pictures
    @item = current_user.items.build( item_params.except(:pictures) )

    if pictures and @item.save
      pictures.each { |picture| @item.pictures.create image: picture }
      redirect_to item_path(@item), notice: t('controller.items.create.success', name: @item.name)
    else
      flash[:alert] = t('controller.action.create.fail')
      render :new
    end
  end

  def edit
  end

  def update
    pictures = item_params.delete :pictures
    if @item.update( item_params.except(:pictures) )
      pictures.each { |picture| @item.pictures.create image: picture } if pictures
      redirect_to item_path(@item), notice: t('controller.items.update.success', name: @item.name) unless remotipart_submitted?
    else
      unless remotipart_submitted?
        flash[:alert] = t('controller.action.create.fail')
        render :edit
      end
    end
  end

  def open
    @item.open!
    redirect_to dashboard_items_path, notice: t('controller.items.open.success', name: @item.name)
  end

  def close
    @item.close!
    redirect_to dashboard_items_path, notice: t('controller.items.close.success', name: @item.name)
  end

  def destroy
    if @item.records.empty?
      @item.destroy
      redirect_to dashboard_items_path, notice: t('controller.items.destroy.success', name: @item.name)
    else
      redirect_to dashboard_items_path, alert: t('controller.items.destroy.fail', name: @item.name)
    end
  end

  def collect
    current_user.collect!(@item)
    result = {
      status: 'ok',
      href: uncollect_item_path(@item, format: :json),
      title: t('controller.items.action.uncollect'),
      method: 'delete',
      class: 'btn-danger'
    }

    respond_to do |format|
      format.json { render json: result }
    end
  end

  def uncollect
    current_user.uncollect!(@item)
    result = {
      status: 'ok',
      href: collect_item_path(@item, format: :json),
      title: t('controller.items.action.collect'),
      method: 'post',
      class: 'btn-default'
    }

    respond_to do |format|
      format.json { render json: result }
    end
  end

  def search
    @items = Item.includes(:pictures, :city, :collectors, lender: [{ profile: :avatar}])
                 .opening
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
        :deliver_fee, deliver_ids: [ ], pictures: [ ]
      )
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
      errors = current_user.profile.validates_basic_info

      unless errors.empty?
        redirect_to edit_user_path(current_user, redirect_url: new_item_path),
                    alert: t('activerecord.errors.models.profile.attributes.info.blank', attrs: errors.join('、'))
      end
    end
end
