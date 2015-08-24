class ItemsController < ApplicationController
  include RentCloudinary
  include UsersReviewsCount

  before_action :login_required, except: [ :index, :show, :search, :reviews ]
  before_action :find_lender_item, only: [ :edit, :update, :destroy ]
  before_action :find_item, only: [ :show, :collect, :uncollect, :calendar, :reviews ]
  before_action :find_reviews, only: [ :show, :reviews ]
  before_action :set_item_meta_tags, :set_item_maps_marker, only: [ :show ]
  before_action :set_picture_public_id, only: [ :create, :update ]
  before_action :find_navbar_categories, except: [ :collect, :uncollect, :calendar, :reviews ]

  def index
    @items = Item.includes(:pictures)
    sort_and_paginate_items
    find_users_reviews_count
    meta_pagination_links @items
  end

  def show
    @question = @item.questions.build
    @rent_record = @item.rent_records.build
    @disabled_dates = @item.booked_dates
  end

  def new
    @item = Item.new
    @item.pictures.build
  end

  def create
    @item = current_user.items.build(item_params)

    if @item.save
      redirect_to item_path(@item)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @item.update(item_params)
      redirect_to item_path(@item)
    else
      render :edit
    end
  end

  def destroy
    @item.destroy
    redirect_to settings_items_path
  end

  def collect
    unless current_user.is_collected?(@item)
      current_user.collect!(@item)
      result = {
        status: "ok",
        href: uncollect_item_path(@item, format: :json),
        method: "delete",
        class: "btn-danger"
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
        status: "ok",
        href: collect_item_path(@item, format: :json),
        method: "post",
        class: "btn-default"
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
    rent_records_json = @item.rent_records.includes(:borrower)
      .overlaps(params[:start], params[:end]).to_json

    respond_to do |format|
      format.json { render json: rent_records_json}
    end
  end

  def reviews
    render partial: "reviews/reviews_list", layout: false, locals: { reviews: @reviews }
  end

  private

    def item_params
      params.require(:item).permit(
        :name, :price, :minimum_period, :city_id, :address,
        :deposit, :down_payment, :description,
        :subcategory_id, deliver_ids: [ ],
        pictures_attributes: [ :public_id ]
      )
    end

    def sort_params
      ( ['price'].include? params[:sort] ) ? params[:sort] : 'items.created_at'
    end

    def find_lender_item
      @item = current_user.items.find(params[:id])
    end

    def find_item
      @item = Item.find(params[:id])
    end

    def sort_and_paginate_items
      @items = @items.order(sort_params)
      @items = @items.reverse_order unless params[:order] == 'asc'
      @items = @items.page(params[:page])
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

    def find_reviews
      @reviews = @item.reviews.where(user_id: @item.lender).page(params[:page])
    end
end
