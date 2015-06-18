class CategoriesController < ApplicationController
  before_action :find_aside_categories, only: [ :show ]
  before_action only: [ :show ] do
    set_category_id(params[:id])
  end

  def show
    @category = Category.find(params[:id])
    @items = @category.items
    render "items/index"
  end
end
