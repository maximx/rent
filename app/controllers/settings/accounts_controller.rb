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
    prev_unconfirmed_email = @user.unconfirmed_email

    if @user.update_with_password(user_params)
      flash_key = if update_needs_confirmation?(@user, prev_unconfirmed_email)
                    :update_needs_confirmation
                  else
                    :updated
                  end
      flash[:notice] = I18n.t("devise.registrations.#{flash_key}")

      sign_in @user, bypass: true
      redirect_to edit_settings_account_path
    else
      render :edit
    end
  end

  def phone_confirmation
    profile = current_user.profile

    if profile.phone_confirmed?
      redirect_with_message settings_account_path, notice: '手機已驗證。'
    end
  end

  def phone_confirmed
    profile = current_user.profile

    if params[:token] == profile.confirmation_token
      profile.phone_confirmed
      redirect_with_message user_path(current_user), notice: '手機驗證成功。'
    else
      flash[:alert] = '驗證碼錯誤，請再確認一次。'
    end
  end

  private

    def update_needs_confirmation?(user, prev_email)
      prev_email != user.unconfirmed_email
    end

    def user_params
      params.require(:user).permit(
        :password, :password_confirmation,
        :email, :current_password, :account
      )
    end
end
