class ItemsController < ApplicationController
  include RentCloudinary

  before_action :login_required, except: [ :index, :show, :search ]
  before_action :find_lender_item, only: [ :edit, :update, :destroy ]
  before_action :find_item, only: [ :show, :collect, :uncollect ]
  before_action :set_picture_public_id, only: [ :create, :update ]

  before_action :find_aside_categories, except: [ :collect, :uncollect ]
  before_action do
    set_category_and_subcategory([@item.category_id, @item.subcategory_id]) if @item
  end

  def index
    @items = Item.all
  end

  def show
    @question = @item.questions.build
    @rent_records_json = @item.active_records.includes(:borrower).to_json

    @maps = Gmaps4rails.build_markers(@item) do |item, marker|
      marker.lat item.latitude
      marker.lng item.longitude
      marker.infowindow("<h4>#{link_of(item)}</h4><br />#{item.address}")
      marker.json({ title: item.name })
    end
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
    current_user.collect!(@item) unless current_user.is_collected?(@item)
    redirect_to item_path(@item)
  end

  def uncollect
    current_user.uncollect!(@item) if current_user.is_collected?(@item)
    redirect_to item_path(@item)
  end

  def search
    @items = Item.record_not_overlaps(params[:started_at], params[:ended_at]).search_by(params[:query])

    render :index
  end

  private

  def item_params
    params.require(:item).permit(
      :name, :price, :minimum_period, :address,
      :deposit, :description, :subcategory_id,
      pictures_attributes: [ :public_id ]
    )
  end

  def find_lender_item
    @item = current_user.items.find(params[:id])
  end

  def find_item
    @item = Item.find(params[:id])
  end

  def link_of(item)
    view_context.link_to( item.name, item_url(item) )
  end

end
