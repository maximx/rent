class RentRecordsController < ApplicationController
  before_action :login_required, except: [ :index ]
  before_action :find_item
  before_action :find_user_rent_record, only: [ :edit, :update, :destroy ]
  before_action :find_item_rent_record, only: [ :show, :review, :renting, :returning, :withdrawing, :ask_for_review ]
  before_action :find_rent_records_json, only: [ :new, :create, :edit, :update ]

  before_action :find_aside_categories
  before_action do
    set_category_and_subcategory([@item.category_id, @item.subcategory_id]) if @item
  end

  def index
    @rent_records = @item.rent_records.includes(:borrower).page(params[:page])
    set_item_maps_marker
  end

  def show
    if @rent_record.viewable_by?(current_user)
      respond_to do |format|
        format.html
        format.pdf do
          pdf = RentRecordPdf.new(@item, @rent_record)

          send_data pdf.render, RentRecordPdf.pdf_config(@item.id, @rent_record.id)
        end
      end
    else
      flash[:alert] = "您沒有權限"
      redirect_to item_path(@item)
    end
  end

  def new
    if current_user != @item.lender
      @rent_record = @item.rent_records.build
      set_start_and_end_params
      set_name_and_phone_from_profile
    else
      flash[:notice] = "您沒有權限"
      redirect_to item_path(@item)
    end
  end

  def create
    @rent_record = @item.rent_records.build(rent_record_params)
    @rent_record.borrower = current_user

    if @rent_record.save
      redirect_to item_path(@item)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @rent_record.update(rent_record_params)
      redirect_to item_rent_record_path(@item, @rent_record)
    else
      render :edit
    end
  end

  def destroy
    @rent_record.destroy
    redirect_to  item_path(@item)
  end

  def review
    if @rent_record.can_review_by?(current_user)
      @review = @rent_record.reviews.build
      set_item_maps_marker
      render "reviews/new"
    else
      flash[:alert] = "您沒有權限"
      redirect_to item_path(@item)
    end
  end

  def ask_for_review
    if @rent_record.is_reviewed_by_judger?(current_user)
      review = @rent_record.review_of_judger(current_user)
      UserMailer.ask_for_review(current_user, review, review.user).deliver
      redirect_to settings_rent_records_path
    else
      flash[:notice] = "請您先行評價"
      redirect_to review_item_rent_record_path(@item, @rent_record)
    end
  end

  def renting
    @rent_record.rent! if @rent_record.can_rent_by?(current_user)
    redirect_to item_rent_records_path(@item)
  end

  def returning
    @rent_record.return! if @rent_record.can_return_by?(current_user)
    redirect_to item_rent_records_path(@item)
  end

  def withdrawing
    @rent_record.withdraw! if @rent_record.can_withdraw_by?(current_user)
    redirect_to item_path(@item)
  end

  private

  def rent_record_params
    params.require(:rent_record).permit(
      :name, :phone,
      :started_at, :ended_at
    )
  end

  def find_item
    @item = Item.find(params[:item_id])
  end

  def find_user_rent_record
    @rent_record = current_user.rent_records.find(params[:id])
  end

  def find_item_rent_record
    @rent_record = @item.rent_records.find(params[:id])
  end

  def find_rent_records_json
    @rent_records_json = @item.active_records.includes(:borrower).to_json
  end

  def set_start_and_end_params
    @rent_record["started_at"] = params[:rent_record_started_at]
    @rent_record["ended_at"] = params[:rent_record_ended_at]
  end

  def set_name_and_phone_from_profile
    if current_user.profile
      @rent_record.name = current_user.profile.name
      @rent_record.phone = current_user.profile.phone
    end
  end

end
