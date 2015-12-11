class Account::VectorsController < ApplicationController
  before_action :login_required
  load_and_authorize_resource :subcategory
  load_and_authorize_resource through: :subcategory

  def index
    @vectors = @vectors.where(user: current_user).includes(:tag, [selections: :tag])
    #items/search 和 item/create 的 input name 不同
    @input_name = (params[:source] == 'users') ? 'selections[]' : 'item[selection_ids][]'

    if params[:item_id].present?
      item = Item.includes(:selections).find(params[:item_id])
      @selections = item.selections_checked
    elsif params[:selections].present?
      @selections = params[:selections]
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
