class Settings::ItemsController < ApplicationController
  before_action :login_required

  def index
    @items = current_user.items
  end
end
