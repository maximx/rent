class UsersController < ApplicationController
  layout 'user'

  include UsersReviewsCount

  before_action :login_required, only: [ :edit, :update, :follow, :unfollow ]
  load_and_authorize_resource id_param: :account, find_by: :account
  before_action :find_profile
  before_action :find_total_reviews, only: [ :show, :edit, :update ]
  before_action :set_user_meta_tags

  def show
    set_maps_marker @profile if @profile.address.present?
  end

  def edit
    set_maps_marker @profile
  end

  def update
    respond_to do |format|
      format.json {
        status = @profile.update(profile_params) ? 'ok' : 'error' if request.xhr?
        render json: {status: status}
      }
      format.html {
        if @profile.update(profile_params)
          if @profile.phone.present? and !@profile.phone_confirmed?
            redirect_to phone_confirmation_account_settings_path(redirect_url: params[:redirect_url]),
                        notice: '手機驗證碼已發送，請輸入所收到之驗證碼。'
          else
            redirect_url = params[:redirect_url] || user_path(@user)
            redirect_to redirect_url, notice: '個人資料修改成功。'
          end
        else
          flash[:alert] = t('controller.action.create.fail')
          render :edit
        end
      }
    end
  end

  def save
    @success = @profile.update_columns(profile_preferences_params)
  end

  def avatar
    if remotipart_submitted?
      if @profile.avatar
        @profile.avatar.update image: params[:profile][:avatar]
      else
        avatar = @profile.build_avatar image: params[:profile][:avatar]
        avatar.save
      end
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
    @items = @user.items.search_and_sort(params)
    find_users_reviews_count
    meta_pagination_links @items

    if request.xhr?
      render partial: 'items/index', locals: { items: @items }
    else
      render :items
    end
  end

  def follow
    current_user.follow! @user
    redirect_to :back
  end

  def unfollow
    current_user.unfollow! @user
    redirect_to user_path(@user)
  end

  private
    def profile_params
      params.require(:profile).permit(
        :name, :address, :phone, :facebook, :line,
        :tel_phone, :description, :bank_code, :bank_account
      )
    end

    def profile_preferences_params
      params.require(:profile).permit(:send_mail)
    end

    def find_total_reviews
      @total_reviews = @user.reviews.group(:rate).count
    end

    def find_profile
      @profile = @user.profile
    end

    def set_user_meta_tags
      set_meta_tags(
        title: @user.profile.logo_name,
        canonical: user_url(@user),
        description: @user.meta_description,
        og: {
          title: @user.account + "的個人資料 - " + t('rent.site_name'),
          description: @user.meta_description,
          type: 'profile',
          url: user_url(@user),
          image: @user.avatar_url
        }
      )
    end
end
