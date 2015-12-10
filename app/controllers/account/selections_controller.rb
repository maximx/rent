class Account::SelectionsController < ApplicationController
  before_action :login_required
  load_and_authorize_resource :vector, through: :current_user
  load_and_authorize_resource through: :vector

  def create
    if @selection.save
      notice_param = { vector: @vector.name, tag: @selection.name }
      redirect_to account_subcategories_path,
                  notice: t('controller.account/selections.create.success', notice_param)
    end
  end

  def destroy
    @selection.destroy
    redirect_to account_subcategories_path
  end

  private
    def selection_params
      params.require(:selection).permit(tag_attributes: [ :name ])
    end
end
