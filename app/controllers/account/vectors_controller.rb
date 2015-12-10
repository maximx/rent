class Account::VectorsController < ApplicationController
  before_action :login_required
  load_and_authorize_resource :subcategory
  load_and_authorize_resource through: :subcategory

  def index
    @vectors = @vectors.where(user: current_user).includes(:tag, [selections: :tag])
    if params[:item_id]
      item = Item.includes(:selections).find(params[:item_id])
      @selections = item.selections_checked
    else
      @selections = []
    end
  end

  def create
    @vector.user = current_user
    @vector.save
  end

  def destroy
    @vector.destroy
  end

  private
    def vector_params
      params.require(:vector).permit(tag_attributes: [ :name ])
    end
end
