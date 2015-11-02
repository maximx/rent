class ProfilesController < ApplicationController
  include FileAttrSetter

  before_action :login_required
  before_action :set_picture_attrs, only: [ :update ]
  before_action :set_user, only: [ :update ]

  def update
    @profile = @user.profile

    if @profile.update(profile_params)
      if @profile.phone_confirmed?
        redirect_with_message user_path(@user), notice: '個人資料修改成功。'
      else
        redirect_with_message phone_confirmation_settings_account_path, notice: '請輸入手機驗證碼'
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
