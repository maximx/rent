class Settings::AccountsController < ApplicationController
  before_action :login_required

  def show
    @user = current_user
    @profile = @user.profile || @user.build_profile
  end

  def edit
    @user = current_user
  end

  def update
    @user = User.find(current_user.id)
    if @user.update_with_password(user_params)
      sign_in @user, bypass: true
      redirect_to settings_account_path
    else
      render :edit
    end
  end

  private

    def user_params
      params.require(:user).permit(
        :password, :password_confirmation,
        :email, :current_password
      )
    end

end
