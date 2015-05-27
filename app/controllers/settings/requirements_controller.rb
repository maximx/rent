class Settings::RequirementsController < ApplicationController
  before_action :login_required

  def index
    @requirements = current_user.requirements
  end
end
