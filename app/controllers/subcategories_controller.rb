class SubcategoriesController < ApplicationController
  include UsersReviewsCount

  before_action :find_subcategory, only: [ :show ]
  before_action :find_navbar_categories, only: [ :show ]

  def show
    @items = @subcategory.items.page(params[:page])
    find_users_reviews_count
    render "items/index"
  end

  private

    def find_subcategory
      @subcategory = Subcategory.find(params[:id])
    end

end
