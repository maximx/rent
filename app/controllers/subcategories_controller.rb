class SubcategoriesController < ApplicationController
  before_action :find_aside_categories, only: [ :show ]
  before_action :find_subcategory, only: [ :show ]
  before_action only: [ :show ] do
    set_category_id(@subcategory.category_id)
  end

  def show
    @items = Item.where(subcategory_id: params[:id])
    render "items/index"
  end

  private

    def find_subcategory
      @subcategory = Subcategory.find(params[:id])
    end

end
