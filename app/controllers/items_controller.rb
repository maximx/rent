class ItemsController < ApplicationController
  include UsersReviewsCount

  before_action :login_required, except: [:index, :show, :search, :calendar]
  before_action :validates_profile, only: [:new, :create]
  load_and_authorize_resource except: [:index, :search]
  before_action :load_categories_grouped_select, only: [:new, :create, :edit, :update]
  before_action :set_item_meta_tags, only: [:show, :edit, :update]
  before_action :set_edit_item_meta_tags, only: [:edit, :update]
  before_action :build_record, :find_item_disabled_dates, only: [:show]

  def index
    @items = Item.includes(:pictures, :collectors, lender: [{ profile: :avatar}])
                 .opening
                 .the_sort(params[:sort])
                 .page(params[:page])
    set_search_item_meta_tags
  end

  def show
    @selections = @item.selections.includes(:tag, [vector: :tag])
    @reviews = @item.reviews.where(user_id: @item.lender).page(params[:page])
  end

  def new
    @item.pictures.build

    set_meta_tags(
      title: "#{t('controller.action.new')}#{t('controller.name.items')}",
      canonical: new_item_url,
      og: {
        title: "#{t('controller.action.new')}#{t('controller.name.items')}",
        url: new_item_url
      }
    )
  end

  def create
    pictures = params[:item][:pictures]
    @item.lender = current_user

    if pictures and @item.save
      pictures.each { |picture| @item.pictures.create image: picture }
      redirect_to item_path(@item), notice: t('controller.action.create.success', name: @item.name)
    else
      flash[:alert] = t('controller.action.create.fail')
      render :new
    end
  end

  def edit
  end

  def update
    pictures = params[:item][:pictures]
    if @item.update( item_params.except(:pictures) )
      pictures.each { |picture| @item.pictures.create image: picture } if pictures
      unless remotipart_submitted?
        redirect_url = params[:redirect_url].present? ? params[:redirect_url] : item_path(@item)
        redirect_to redirect_url, notice: t('controller.action.update.success', name: @item.name)
      end
    else
      unless remotipart_submitted?
        flash[:alert] = t('controller.action.create.fail')
        render :edit
      end
    end
  end

  def open
    if @item.valid? and @item.pictures.present?
      @item.open!
      redirect_to lender_items_path, notice: t('controller.items.open.success', name: @item.name)
    else
      redirect_to edit_item_path(@item, redirect_url: lender_items_path),
                  alert: t('controller.items.open.fail', name: @item.name)
    end
  end

  def close
    @item.close!
    redirect_to lender_items_path, notice: t('controller.items.close.success', name: @item.name)
  end

  def destroy
    @item.destroy
    redirect_to lender_items_path, notice: t('controller.items.destroy.success', name: @item.name)
  end

  def collect
    current_user.collect!(@item)
    result = {
      status: 'ok',
      href: uncollect_item_path(@item, format: :json),
      title: t('controller.items.action.uncollect'),
      method: 'delete',
      class: 'btn-danger'
    }

    respond_to do |format|
      format.json { render json: result }
    end
  end

  def uncollect
    current_user.uncollect!(@item)
    result = {
      status: 'ok',
      href: collect_item_path(@item, format: :json),
      title: t('controller.items.action.collect'),
      method: 'post',
      class: 'btn-default'
    }

    respond_to do |format|
      format.json { render json: result }
    end
  end

  def search
    @items = Item.search_and_sort(params)

    if request.xhr?
      render partial: 'items/index', locals: { items: @items }
    else
      set_search_item_meta_tags
      render :index
    end
  end

  def calendar
    @event_sources_path = calendar_item_path(@item, format: :json)
    records_json = @item.records
                        .includes(borrower: :profile)
                        .actived
                        .overlaps(params[:start], params[:end])
                        .to_json(user: current_user)
    respond_to do |format|
      format.json {render json: records_json} if request.xhr?
    end
  end

  private
    def item_params
      params.require(:item).permit(
        :product_id, :name, :price, :period, :minimum_period,
        :deposit, :description, :subcategory_id,
        :deliver_fee, deliver_ids: [],
        selection_ids: []
      )
    end

    def set_item_meta_tags
      set_meta_tags(
        title: @item.name,
        keywords: @item.meta_keywords,
        description: @item.meta_description,
        canonical: item_url(@item),
        og: {
          title: @item.name,
          description: @item.meta_description,
          url: item_url(@item),
          image: @item.pictures_urls
        }
      )
    end

    def set_edit_item_meta_tags
      title = "#{t('controller.action.edit')}#{@item.name}"
      set_meta_tags title: title, og: {title: title}
    end

    def set_search_item_meta_tags
      title = t('controller.action.index', query: (params[:query].blank? ? t('activerecord.models.item') : params[:query]))
      meta_pagination_links @items
      set_meta_tags(
        title: title,
        canonical: items_url,
        og: {
          title: title,
          url: items_url
        }
      )
    end

    def find_item_disabled_dates
      @disabled_dates = @item.booked_dates
    end

    def load_categories_grouped_select
      @categories_grouped_select = Category.grouped_select
    end

    def build_record
      @record = @item.records.build
    end

    def validates_profile
      errors = current_user.profile.validates_basic_info

      unless errors.empty?
        redirect_to edit_user_path(current_user, redirect_url: new_item_path),
                    alert: t('activerecord.errors.models.profile.attributes.info.blank', attrs: errors.join('、'))
      end
    end
end
