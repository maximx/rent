class ProfilesController < ApplicationController
  include RentCloudinary

  before_action :login_required
  before_action :set_picture_public_id, only: [ :create, :update ]
  before_action :set_user, only: [ :create, :update ]

  def create
    @profile = @user.build_profile(profile_params)
    save_profile @profile.save
  end

  def update
    @profile = @user.profile
    save_profile @profile.update(profile_params)
  end

  private

    def profile_params
      params.require(:profile).permit(:name, :address, :phone, :description, picture_attributes: [ :public_id ])
    end

    def save_profile(is_success)
      if is_success
        flash[:notice] = "修改成功"
        redirect_to settings_account_index_path
      else
        render "settings/account/index"
      end
    end

    def set_user
      @user = current_user
    end
end
