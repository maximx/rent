class CategoriesController < ApplicationController
  include UsersReviewsCount

  before_action :find_navbar_categories, only: [ :show ]

  def show
    @category = Category.find(params[:id])
    @items = @category.items.page(params[:page])
    @obj = @category
    find_users_reviews_count
    render "items/index"
  end
end
