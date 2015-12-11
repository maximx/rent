class CategoriesController < ApplicationController
  include UsersReviewsCount
  include SortPaginate

  def show
    @category = Category.find(params[:id])
    @breadcrumbs_object = @category
    @items = @category.items.opening.includes(:pictures, :city, :collectors, lender: [{ profile: :avatar}])
    sort_and_paginate_items
    find_users_reviews_count
    set_category_meta_tags
    render 'items/index'
  end

  private

    def set_category_meta_tags
      meta_pagination_links @items

      set_meta_tags(
        title: @category.name,
        keywords: @category.meta_keywords,
        description: @category.meta_description,
        og: {
          title: @category.name,
          description: @category.meta_description,
          url: url_for(params),
          image: @items.cover_pictures_urls
        }
      )
    end
end
