class Settings::AccountController < ApplicationController
  before_action :login_required

  def index
    current_user.build_profile unless current_user.profile
  end
end
