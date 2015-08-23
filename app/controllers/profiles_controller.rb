class ProfilesController < ApplicationController
  include RentCloudinary

  layout "application_aside"

  before_action :login_required
  before_action :set_picture_public_id, only: [ :create, :update ]
  before_action :set_user, only: [ :create, :update ]

  def create
    @profile = @user.build_profile(profile_params)
    after_save_profile @profile.save
  end

  def update
    @profile = @user.profile
    after_save_profile @profile.update(profile_params)
  end

  private

    def profile_params
      params.require(:profile).permit(
        :name, :address, :phone,
        :description, :bank_code, :bank_account,
        picture_attributes: [ :public_id ]
      )
    end

    def after_save_profile(is_success)
      if is_success
        flash[:notice] = "修改成功"
        redirect_to settings_account_path
      else
        render "settings/accounts/show"
      end
    end

    def set_user
      @user = current_user
    end
end
