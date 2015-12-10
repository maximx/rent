class Account::VectorsController < ApplicationController
  before_action :login_required
  load_and_authorize_resource :subcategory
  load_and_authorize_resource through: :subcategory

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
