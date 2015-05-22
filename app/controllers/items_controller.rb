class ItemsController < ApplicationController
  before_action :login_require, except: [ :index, :show ]
  before_action :find_item, only: [ :edit, :update, :destroy ]

  def index
    @items = Item.all
  end

  def show
    @item = Item.find(params[:id])
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
    params.require(:item).permit(:name, :price, :period, :address, :deposit, :description)
  end

  def find_item
    @item = current_user.items.find(params[:id])
  end
end
