class CategoriesController < ApplicationController
  include UsersReviewsCount

  before_action :find_navbar_categories, only: [ :show ]

  def show
    @category = Category.find(params[:id])
    @items = @category.items.page(params[:page])
    @breadcrumbs_object = @category
    find_users_reviews_count
    set_category_meta_tags
    render "items/index"
  end

  private

    def set_category_meta_tags
      meta_pagination_links @items

      set_meta_tags(
        title: @category.name,
        keywords: @category.meta_keywords,
        og: {
          title: @category.name,
          #TODO: description
          url: url_for(params),
          image: @items.index_pictures_urls
        }
      )
    end
end
