class UsersController < ApplicationController
  layout 'user'

  include UsersReviewsCount
  include FileAttrSetter
  include SortPaginate

  before_action :login_required, only: [ :follow, :unfollow ]
  before_action :find_user, :find_profile, :set_user_meta_tags
  before_action :find_total_reviews, only: [ :show, :edit, :update ]
  before_action :validate_editable, only: [ :edit, :update ]
  before_action :set_avatar_attr, only: [ :update ]

  def show
    set_maps_marker @profile
  end

  def edit
    set_maps_marker @profile
  end

  def update
    if @profile.update(profile_params)
      unless remotipart_submitted?
        if @profile.phone.present? and !@profile.phone_confirmed?
          redirect_with_message phone_confirmation_settings_account_path,
                                notice: '手機驗證碼已發送，請輸入所收到之驗證碼。'
        else
          redirect_with_message user_path(@user), notice: '個人資料修改成功。'
        end
      end
    else
      render :edit unless remotipart_submitted?
    end
  end

  def reviews
    @grouped_reviews_count = @user.reviews.group(:user_role).count
    @lender_reviews = @user.reviews_of('lender').page(params[:page])
    @borrower_reviews = @user.reviews_of('borrower').page(params[:page])
  end

  def lender_reviews
    if request.xhr?
      reviews = @user.reviews_of("lender").page(params[:page])
      render partial: "reviews/reviews_list", layout: false, locals: { reviews: reviews }
    end
  end

  def borrower_reviews
    if request.xhr?
      reviews = @user.reviews_of("borrower").page(params[:page])
      render partial: "reviews/reviews_list", layout: false, locals: { reviews: reviews }
    end
  end

  def items
    @items = @user.items.includes(:pictures, :city, :collectors, lender: [{ profile: :avatar}])
    sort_and_paginate_items
    find_users_reviews_count
    meta_pagination_links @items
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

    def profile_params
      params.require(:profile).permit(
        :name, :address, :phone, :facebook, :line,
        :description, :bank_code, :bank_account, :send_mail,
        avatar_attributes: [ :id, :public_id, :file_cached ]
      )
    end

    def find_user
      @user = User.includes(:covers, profile: :avatar).find(params[:id])
    end

    def find_total_reviews
      @total_reviews = @user.reviews.group(:rate).count
    end

    def find_profile
      @profile = @user.profile || @user.build_profile
    end

    def set_user_meta_tags
      set_meta_tags(
        title: @user.account,
        canonical: user_url(@user),
        description: @user.meta_description,
        og: {
          title: @user.account + "的個人資料 - " + Rent::SITE_NAME,
          description: @user.meta_description,
          type: 'profile',
          url: user_url(@user),
          image: @user.picture_url
        }
      )
    end

    def validate_editable
      redirect_with_message user_path(@user) unless @user == current_user
    end
end
