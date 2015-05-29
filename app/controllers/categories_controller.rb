class CategoriesController < ApplicationController
  before_action :find_categories, only: [ :show ]

  def show
    @items = Item.where(category_id: params[:id])
    render "items/index"
  end
end
