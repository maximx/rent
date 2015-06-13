class ProfilesController < ApplicationController
  before_action :login_required

  def create
    @profile = current_user.build_profile(profile_params)
    if @profile.save
      flash[:notice] = "修改成功"
      redirect_to settings_account_index_path
    else
      render "settings/account/index"
    end
  end

  def update
    @profile = current_user.profile
    if @profile.update(profile_params)
      flash[:notice] = "修改成功"
      redirect_to settings_account_index_path
    else
      render "settings/account/index"
    end
  end

  private

    def profile_params
      params.require(:profile).permit(:name, :address, :phone, :description)
    end
end
