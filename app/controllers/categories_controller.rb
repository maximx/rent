class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @breadcrumbs_object = @category
    @items = @category.items
                      .includes(:pictures, :collectors, lender: [{ profile: :avatar}])
                      .opening
                      .the_sort(params[:sort])
                      .page(params[:page])
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
