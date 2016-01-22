class Account::SettingsController < ApplicationController
  before_action :login_required, :load_user
  before_action :load_profile, except: [ :update ]

  def show
  end

  def preferences
  end

  def lender
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
    if remotipart_submitted?
      if @user.cover.present?
        @user.cover.update image: params[:user][:cover]
      else
        cover = @user.create_cover image: params[:user][:cover]
      end
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

  def save
    if @user.update(user_lender_params)
      redirect_to lender_account_settings_path, notice: t('controller.account/settings.save.success')
    else
      flash[:alert] = t('common.error')
      render :lender
    end
  end

  def become
    return unless current_user.id == 1
    sign_in(:user, User.find(params[:id]), {:bypass => true})
    redirect_to root_url
  end

  private
    def user_params
      params.require(:user).permit(
        :email, :account, :password,
        :password_confirmation, :current_password
      )
    end

    def user_lender_params
      params.require(:user).permit(:free_days, :borrower_info_provide, deliver_ids: [])
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
