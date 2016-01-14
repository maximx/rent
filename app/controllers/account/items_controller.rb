class Account::ItemsController < ApplicationController
  before_action :login_required
  load_and_authorize_resource :customer, through: :current_user
  load_and_authorize_resource :item, through: :current_user

  def index
    @items = @items.includes(:records, :lender)
                   .search_by(params[:query])
                   .the_sort(params[:sort])
                   .page(params[:page])
  end
end
