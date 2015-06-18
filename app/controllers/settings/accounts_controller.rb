class Settings::AccountsController < ApplicationController
  before_action :login_required

  def show
    @user = current_user
    @profile = @user.profile || @user.build_profile
  end

end
