class Settings::AccountsController < ApplicationController
  before_action :login_required, :find_user
  before_action :find_profile, only: [ :show, :save, :phone_confirmation, :phone_confirmed ]

  def show
  end

  def save
    if @profile.update(profile_params)
      respond_to do |format|
        result = { status: 'ok' }

        format.json { render json: result } if request.xhr?
        format.html { redirect_to settings_account_path, notice: t('controller.settings/account.save.success') }
      end
    else
      respond_to do |format|
        result = { status: 'error' }
        format.json { render json: result } if request.xhr?
        format.html { redirect_to settings_account_path, alert: t('common.error') }
      end
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
      flash[:notice] = t("devise.registrations.#{flash_key}")

      sign_in @user, bypass: true
      redirect_to edit_settings_account_path
    else
      render :edit
    end
  end

  def phone_confirmation
    if @profile.phone_confirmed?
      redirect_url = params[:redirect_url] || user_path(@user)
      redirect_with_message redirect_url, notice: '手機已驗證。'
    end
  end

  def phone_confirmed
    if params[:token] == @profile.confirmation_token
      @profile.phone_confirmed
      redirect_url = params[:redirect_url] || user_path(@user)
      redirect_with_message redirect_url, notice: '手機驗證成功。'
    else
      flash[:alert] = '驗證碼錯誤，請再確認一次。'
    end
  end

  def upload
    if remotipart_submitted? and params[:user][:covers]
      params[:user][:covers].each do |cover|
        @user.covers.create image: cover
      end
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

    def profile_params
      params.require(:profile).permit(:send_mail, :borrower_info_provide, :bank_code, :bank_account)
    end

    def find_user
      @user = User.find current_user.id
    end

    def find_profile
      @profile = @user.profile
    end
end
