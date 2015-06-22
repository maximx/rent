class SubcategoriesController < ApplicationController
  before_action :find_subcategory, only: [ :show ]

  before_action :find_aside_categories, only: [ :show ]
  before_action only: [ :show ] do
    set_category_and_subcategory([@subcategory.category_id, @subcategory.id])
  end

  def show
    @items = @subcategory.items
    render "items/index"
  end

  private

    def find_subcategory
      @subcategory = Subcategory.find(params[:id])
    end

end
