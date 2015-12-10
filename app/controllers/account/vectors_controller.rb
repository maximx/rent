class Account::VectorsController < ApplicationController
  before_action :login_required
  load_and_authorize_resource :subcategory
  load_and_authorize_resource through: :subcategory

  def create
    @vector.user = current_user
    if @vector.save
      notice_param = { subcategory: @subcategory.name, tag: @vector.tag.name }
      redirect_to account_categories_path,
                  notice: t('controller.account/vectors.create.success', notice_param)
    end
  end

  def destroy
    @vector.destroy
    redirect_to account_categories_path
  end

  private
    def vector_params
      params.require(:vector).permit(tag_attributes: [ :name ])
    end
end
