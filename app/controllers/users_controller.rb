class UsersController < ApplicationController
  before_action :login_required, only: [ :follow, :unfollow ]
  before_action :find_user, only: [ :follow, :unfollow ]

  def show
    @user = User.includes(:items).find(params[:id])
    @profile = @user.profile || @user.build_profile
  end

  def follow
    unless current_user.is_following?(@user)
      current_user.follow!(@user)
    end

    redirect_to user_path(@user)
  end

  def unfollow
    if current_user.is_following?(@user)
      current_user.unfollow!(@user)
    end

    redirect_to user_path(@user)
  end

  private

  def find_user
    @user = User.find(params[:id])
  end
end
