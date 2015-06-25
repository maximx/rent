class UsersController < ApplicationController
  before_action :login_required, only: [ :follow, :unfollow ]
  before_action :find_user
  before_action :find_profile

  def show
  end

  def items
    @items = @user.items
    find_profile
  end

  def lender_reviews
    @reviews = @user.lender_reviews
    render :reviews
  end

  def borrower_reviews
    @reviews = @user.borrower_reviews
    render :reviews
  end

  def following
    @followings = @user.following
  end

  def items_collect
    @items = @user.collections
    render :items
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

    def find_profile
      @profile = @user.profile || @user.build_profile
    end
end
