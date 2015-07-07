class CategoriesController < ApplicationController
  include UsersReviewsCount

  before_action :find_aside_categories, only: [ :show ]
  before_action only: [ :show ] do
    set_category_and_subcategory(params[:id])
  end

  def show
    @category = Category.find(params[:id])
    @items = @category.items.page(params[:page])
    find_users_reviews_count
    render "items/index"
  end
end
