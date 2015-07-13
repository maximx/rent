class ItemsController < ApplicationController
  include RentCloudinary
  include UsersReviewsCount

  before_action :login_required, except: [ :index, :show, :search ]
  before_action :find_lender_item, only: [ :edit, :update, :destroy ]
  before_action :find_item, only: [ :show, :collect, :uncollect ]
  before_action :set_picture_public_id, only: [ :create, :update ]
  before_action :find_navbar_categories, except: [ :collect, :uncollect ]

  def index
    @items = Item.includes(:pictures).page(params[:page])
    find_users_reviews_count
  end

  def show
    @question = @item.questions.build
    @rent_records_json = @item.active_records.includes(:borrower).to_json
    set_item_maps_marker
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
    @items = Item.includes(:pictures).search_city(params[:city])
                 .search_by(params[:query]).page(params[:page])
    find_users_reviews_count

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

end
