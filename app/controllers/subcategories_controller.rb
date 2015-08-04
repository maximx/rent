class SubcategoriesController < ApplicationController
  include UsersReviewsCount

  before_action :find_subcategory, only: [ :show ]
  before_action :find_navbar_categories, only: [ :show ]

  def show
    @items = @subcategory.items.page(params[:page])
    @breadcrumbs_object = @subcategory
    find_users_reviews_count
    set_subcategory_meta_tags
    render "items/index"
  end

  private

    def find_subcategory
      @subcategory = Subcategory.find(params[:id])
    end

    def set_subcategory_meta_tags
      meta_pagination_links @items

      set_meta_tags(
        title: @subcategory.title,
        keywords: @subcategory.meta_keywords,
        description: @subcategory.meta_description,
        og: {
          title: @subcategory.title,
          description: @subcategory.meta_description,
          url: url_for(params),
          image: @items.index_pictures_urls
        }
      )
    end
end
