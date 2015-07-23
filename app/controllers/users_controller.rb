class UsersController < ApplicationController
  include UsersReviewsCount

  layout "application_aside"

  before_action :login_required, only: [ :follow, :unfollow ]
  before_action :find_user, :find_total_reviews, :find_profile, :set_user_meta_tags

  def show
  end

  def items
    @items = @user.items.page(params[:page])
    find_profile
    find_users_reviews_count
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
    @items = @user.collections.page(params[:page])
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
      result = { status: "ok" }
    end

    respond_to do |format|
      format.html { redirect_to user_path(@user) }
      format.json { render json: result }
    end
  end

  private

    def find_user
      @user = User.find(params[:id])
    end

    def find_total_reviews
      @total_reviews = @user.reviews.group(:rate).count
    end

    def find_profile
      @profile = @user.profile || @user.build_profile
    end

    def set_user_meta_tags
      set_meta_tags(
        title: @profile.name,
        keywords: @user.meta_keywords,
        canonical: user_url(@user),
        og: {
          title: @profile.name,
          type: "profile",
          #TODO: description
          url: user_url(@user),
          image: @user.picture_url
        }
      )
    end
end
