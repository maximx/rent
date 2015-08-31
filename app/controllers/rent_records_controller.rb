class RentRecordsController < ApplicationController
  before_action :login_required, except: [ :index ]
  before_action :find_item
  before_action :find_user_rent_record, only: [ :edit, :update ]
  before_action :find_item_rent_record, only: [ :show, :review, :remitting, :delivering, :renting,
                                                :returning, :withdrawing, :ask_for_review ]
  before_action :find_navbar_categories
  before_action :set_calendar_event_sources_path, :find_disabled_dates, only: [ :new, :create, :edit, :update ]

  def index
    @is_xhr = (request.xhr?) ? true : false
    @rent_records = @item.rent_records.includes(:borrower).rencent.reverse_order.page(params[:page])
    set_item_maps_marker unless @is_xhr
    render :index, layout: !@is_xhr
  end

  def show
    @event_sources_path = item_rent_record_path(@item, @rent_record)
    rent_record_dates = @rent_record.aasm_state_dates_json

    if @rent_record.viewable_by?(current_user)
      respond_to do |format|
        format.html
        format.json { render json: rent_record_dates }
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
    else
      flash[:notice] = "您沒有權限"
      redirect_to item_path(@item)
    end
  end

  def create
    @rent_record = @item.rent_records.build(rent_record_params)
    @rent_record.borrower = current_user

    if @rent_record.save
      redirect_to item_rent_record_path(@item, @rent_record)
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

  def remitting
    @rent_record.remit! if @rent_record.can_remit_by?(current_user)
    redirect_to :back
  end

  def delivering
    @rent_record.delivery! if @rent_record.can_delivery_by?(current_user)
    @rent_record.rent! if @rent_record.can_rent_by?(current_user)
    redirect_to :back
  end

  def renting
    @rent_record.rent! if @rent_record.can_rent_by?(current_user)
    redirect_to :back
  end

  def returning
    @rent_record.return! if @rent_record.can_return_by?(current_user)
    redirect_to :back
  end

  def withdrawing
    @rent_record.withdraw! if @rent_record.can_withdraw_by?(current_user)
    redirect_to :back
  end

  private

  def rent_record_params
    params.require(:rent_record).permit(
      :name, :phone, :deliver_id,
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

  def set_calendar_event_sources_path
    @event_sources_path = calendar_item_path(@item, format: :json)
  end

  def find_disabled_dates
    @disabled_dates = @item.booked_dates
  end

  def set_start_and_end_params
    @rent_record["started_at"] = params[:rent_record_started_at]
    @rent_record["ended_at"] = params[:rent_record_ended_at]
  end
end
