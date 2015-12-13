class Account::SelectionsController < ApplicationController
  before_action :login_required
  load_and_authorize_resource :vector, through: :current_user
  load_and_authorize_resource through: :vector

  def create
    @selection.user = current_user
    @selection.save
  end

  def destroy
    @selection.destroy
  end

  private
    def selection_params
      params.require(:selection).permit(tag_attributes: [ :name ])
    end
end
