class ProfilesController < ApplicationController
  include FileAttrSetter

  before_action :login_required
  before_action :set_avatar_attr, only: [ :update ]
  before_action :set_user, only: [ :update, :update_bank_info ]

  def update
    @profile = @user.profile

    if @profile.update(profile_params)
      if @profile.phone.present? and !@profile.phone_confirmed?
        redirect_with_message phone_confirmation_settings_account_path,
                              notice: '手機驗證碼已發送，請輸入所收到之驗證碼。'
      else
        redirect_with_message user_path(@user), notice: '個人資料修改成功。'
      end
    else
      render 'settings/accounts/show'
    end
  end

  def update_bank_info
    result = { status: 'error' }

    if request.xhr?
      profile = @user.profile
      result = { status: 'ok' } if profile.update(profile_params)
    end

    respond_to do |format|
      format.json { render json: result }
    end
  end

  private

    def profile_params
      params.require(:profile).permit(
        :name, :city_id, :address, :phone, :facebook, :line,
        :description, :bank_code, :bank_account,
        avatar_attributes: [ :id, :public_id, :file_cached ]
      )
    end

    def set_user
      @user = current_user
    end
end
