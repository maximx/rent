class UsersController < ApplicationController
  before_action :login_required, only: [ :follow, :unfollow ]

  def show
    @user = User.includes(:items).find(params[:id])
  end

  def follow
  end

  def unfollow
  end
end
