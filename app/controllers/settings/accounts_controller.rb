class Settings::AccountsController < ApplicationController
  layout "application_aside"

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
