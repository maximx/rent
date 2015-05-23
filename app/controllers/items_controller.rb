class ItemsController < ApplicationController
  before_action :login_required, except: [ :index, :show ]
  before_action :find_item, only: [ :edit, :update, :destroy ]

  def index
    @items = Item.all
  end

  def show
    @item = Item.find(params[:id])
    @question = @item.questions.build
    @maps = Gmaps4rails.build_markers(@item) do |item, marker|
      url = view_context.link_to(item.name, item_url(item))
      marker.lat item.latitude
      marker.lng item.longitude
      marker.infowindow("<h4>#{url}</h4><br />#{item.address}")
      marker.json({ title: item.name })
    end
  end

  def new
    @item = Item.new
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
    redirect_to items_path
  end

  private

  def item_params
    params.require(:item).permit(
      :name, :price, :period, :address,
      :deposit, :description, :category_id, :subcategory_id
    )
  end

  def find_item
    @item = current_user.items.find(params[:id])
  end
end
