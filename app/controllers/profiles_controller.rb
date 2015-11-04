class ProfilesController < ApplicationController
  include FileAttrSetter

  before_action :login_required
  before_action :set_picture_attrs, only: [ :update ]
  before_action :set_user, only: [ :update ]

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

  private

    def profile_params
      params.require(:profile).permit(
        :name, :city_id, :address, :phone,
        :description, :bank_code, :bank_account,
        picture_attributes: [ :public_id, :file_cached ]
      )
    end

    def set_user
      @user = current_user
    end
end
