class Account::SettingsController < ApplicationController
  before_action :login_required, :load_user
  before_action :load_profile, except: [ :update ]

  def show
  end

  def preferences
  end

  def phone_confirmation
    if @profile.phone_confirmed?
      redirect_url = params[:redirect_url] || user_path(@user)
      redirect_to redirect_url, notice: t('controller.account/settings.phone_confirmation.confirmed')
    end
  end

  def phone_confirmed
    if params[:token] == @profile.confirmation_token
      @profile.phone_confirmed
      redirect_url = params[:redirect_url] || user_path(@user)
      redirect_to redirect_url, notice: t('controller.account/settings.phone_confirmed.success')
    else
      flash[:alert] = t('controller.account/settings.phone_confirmed.fail')
      render :phone_confirmation
    end
  end

  def upload
    if remotipart_submitted? and params[:user][:covers]
      params[:user][:covers].each do |cover|
        @user.covers.create image: cover
      end
    end
  end

  def save
    respond_to do |format|
      if request.xhr?
        format.json {
          if @profile.update(profile_params)
            result = { status: 'ok' }
          else
            result = { status: 'error' }
          end
          render json: result
        }
      end

      format.html {
        if @profile.update_columns(profile_preferences_params)
          redirect_to preferences_account_settings_path,
                      notice: t('controller.account/settings.save.success')
        else
          redirect_to preferences_account_settings_path, alert: t('common.error')
        end
      }
    end
  end

  # accoutn settings, need password
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
      redirect_to account_settings_path
    else
      flash[:alert] = t('controller.action.create.fail')
      render :show
    end
  end

  private
    def user_params
      params.require(:user).permit(
        :email, :account, :password,
        :password_confirmation, :current_password
      )
    end

    def profile_params
      params.require(:profile).permit(
        :send_mail, :borrower_info_provide,
        :bank_code, :bank_account
      )
    end

    def profile_preferences_params
      params.require(:profile).permit(
        :send_mail, :borrower_info_provide,
        :bank_code, :bank_account
      )
    end

    def load_user
      @user = User.find current_user.id
    end

    def load_profile
      @profile = @user.profile
    end

    def update_needs_confirmation?(user, prev_email)
      prev_email != user.unconfirmed_email
    end
end
