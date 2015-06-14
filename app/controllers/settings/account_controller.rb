class Settings::AccountController < ApplicationController
  before_action :login_required

  def index
    @profile = if current_user.profile
                 current_user.profile
               else
                 current_user.build_profile
               end
  end
end
