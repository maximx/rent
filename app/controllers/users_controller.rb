class UsersController < ApplicationController
  include UsersReviewsCount

  before_action :login_required, only: [ :follow, :unfollow ]
  before_action :find_user, :find_total_reviews, :find_profile, :set_user_meta_tags

  def show
    @items = @user.items.select(:id, :name)
    @user_lender_reviews = @user.lender_reviews
    @user_borrower_reviews = @user.borrower_reviews
    @followings = @user.following
  end

  #TODO: ajax load review
  def lender_reviews
    @reviews = @user.lender_reviews
    render :reviews
  end

  def borrower_reviews
    @reviews = @user.borrower_reviews
    render :reviews
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

    #TODO: description
    def set_user_meta_tags
      set_meta_tags(
        title: @user.account,
        canonical: user_url(@user),
        og: {
          title: @user.account + "的個人資料 - " + SITE_NAME,
          type: "profile",
          url: user_url(@user),
          image: @user.picture_url
        }
      )
    end
end
