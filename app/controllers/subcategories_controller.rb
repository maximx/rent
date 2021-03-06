class SubcategoriesController < ApplicationController
  def show
    @subcategory = Subcategory.find(params[:id])
    @breadcrumbs_object = @subcategory
    @items = @subcategory.items
                         .includes(:pictures, :collectors, lender: [{ profile: :avatar}])
                         .opening
                         .the_sort(params[:sort])
                         .page(params[:page])
    set_subcategory_meta_tags
    render 'items/index'
  end

  private
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
          image: @items.cover_pictures_urls
        }
      )
    end
end
