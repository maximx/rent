class ProfilesController < ApplicationController
  before_action :login_required

  def create
    @profile = current_user.build_profile(profile_params)
    save_profile @profile.save
  end

  def update
    @profile = current_user.profile
    save_profile @profile.update(profile_params)
  end

  private

    def profile_params
      params.require(:profile).permit(:name, :address, :phone, :description)
    end

    def save_profile(is_success)
      if is_success
        flash[:notice] = "修改成功"
        redirect_to settings_account_index_path
      else
        render "settings/account/index"
      end
    end
end
