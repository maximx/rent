class CategoriesController < ApplicationController
  include UsersReviewsCount

  before_action :find_navbar_categories, only: [ :show ]

  def show
    @category = Category.find(params[:id])
    @items = @category.items.page(params[:page])
    @breadcrumbs_object = @category
    find_users_reviews_count
    meta_pagination_links @items
    render "items/index"
  end
end
