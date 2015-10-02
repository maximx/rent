class UsersController < ApplicationController
  before_action :login_required, only: [ :follow, :unfollow ]
  before_action :find_user, :find_total_reviews, :find_profile, :set_user_meta_tags, :find_user_items

  def show
    @followings = @user.following
    @grouped_reviews_count = @user.reviews.group(:user_role).count
    @lender_reviews = @user.reviews_of('lender').page(params[:page])
    @borrower_reviews = @user.reviews_of('borrower').page(params[:page])
  end

  def lender_reviews
    reviews = @user.reviews_of("lender").page(params[:page])
    render partial: "reviews/reviews_list", layout: false, locals: { reviews: reviews }
  end

  def borrower_reviews
    reviews = @user.reviews_of("borrower").page(params[:page])
    render partial: "reviews/reviews_list", layout: false, locals: { reviews: reviews }
  end

  def follow
    unless current_user.is_following?(@user)
      current_user.follow!(@user)
      result = {
        status: 'ok',
        text: view_context.render_icon_with_text('star', '取消追蹤'),
        href: unfollow_user_path(@user, format: :json),
        method: 'delete'
      }
    end

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render json: result }
    end
  end

  def unfollow
    if current_user.is_following?(@user)
      current_user.unfollow!(@user)
      result = {
        status: 'ok',
        text: view_context.render_icon_with_text('star-empty', '追蹤'),
        href: follow_user_path(@user, format: :json),
        method: 'put'
      }
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

    def find_user_items
      @items = @user.items.select(:id, :name)
    end

    def set_user_meta_tags
      set_meta_tags(
        title: @user.account,
        canonical: user_url(@user),
        description: @user.meta_description,
        og: {
          title: @user.account + "的個人資料 - " + Rent::SITE_NAME,
          description: @user.meta_description,
          type: "profile",
          url: user_url(@user),
          image: @user.picture_url
        }
      )
    end
end
