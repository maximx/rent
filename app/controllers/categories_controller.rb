class CategoriesController < ApplicationController
  before_action :find_aside_categories, only: [ :show ]
  before_action only: [ :show ] do
    set_category_id(params[:id])
  end

  def show
    @items = Item.where(category_id: params[:id])
    render "items/index"
  end
end
