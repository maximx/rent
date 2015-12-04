class Settings::AccountsController < ApplicationController
  include FileAttrSetter

  before_action :login_required, :find_user
  before_action :find_profile, only: [ :show, :save, :phone_confirmation, :phone_confirmed ]
  before_action :set_covers_attr, only: [ :upload ]

  def show
  end

  def save
    if @profile.update(profile_params)
      redirect_with_message settings_account_path, notice: t('controller.settings/account.save.success')
    else
      redirect_with_message settings_account_path, alert: t('common.error')
    end
  end

  def edit
  end

  def update
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
    if @profile.phone_confirmed?
      redirect_with_message user_path(@user), notice: '手機已驗證。'
    end
  end

  def phone_confirmed
    if params[:token] == @profile.confirmation_token
      @profile.phone_confirmed
      redirect_with_message user_path(@user), notice: '手機驗證成功。'
    else
      flash[:alert] = '驗證碼錯誤，請再確認一次。'
    end
  end

  def upload
    if remotipart_submitted?
      result = { status: 'error' }
      @user.update(user_params)
    end
  end

  private

    def update_needs_confirmation?(user, prev_email)
      prev_email != user.unconfirmed_email
    end

    def user_params
      params.require(:user).permit(
        :password, :password_confirmation,
        :email, :current_password, :account,
        covers_attributes: [ :public_id, :file_cached ]
      )
    end

    def profile_params
      params.require(:profile).permit(:send_mail, :borrower_info_provide)
    end

    def find_user
      @user = User.find current_user.id
    end

    def find_profile
      @profile = @user.profile
    end
end
