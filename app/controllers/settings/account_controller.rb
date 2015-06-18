class Settings::AccountController < ApplicationController
  before_action :login_required

  def index
    @user = current_user
    @profile = @user.profile || @user.build_profile
  end

end
