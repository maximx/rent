class ProfilesController < ApplicationController
  before_action :login_required
  before_action :set_user, only: [ :update_bank_info ]

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

    def set_user
      @user = current_user
    end
end
