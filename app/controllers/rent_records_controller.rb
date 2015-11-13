class RentRecordsController < ApplicationController
  include FileAttrSetter

  before_action :login_required, except: [ :index ]
  before_action :find_item, :find_navbar_categories
  before_action :validates_item_rentable, only: [ :new, :create ]
  before_action :find_item_rent_record, only: [ :show, :review, :remitting, :delivering, :renting,
                                                :returning, :withdrawing, :ask_for_review ]
  before_action :set_calendar_event_sources_path, :find_disabled_dates, only: [ :new, :create ]
  before_action :set_attachments_attr, only: [ :renting ]

  def index
    @rent_records = @item.rent_records.includes(:borrower).rencent.reverse_order.page(params[:page])
  end

  def show
    if @rent_record.viewable_by?(current_user)
      rent_record_dates = @rent_record.aasm_state_dates_json
      @rent_record_state_logs = @rent_record.rent_record_state_logs
      @rent_record_state_log = @rent_record_state_logs.build

      respond_to do |format|
        format.html do
          ( request.xhr? ) ? render('rent_records/show_popover', layout: false) : :show
        end
        format.pdf do
          pdf = RentRecordPdf.new(@item, @rent_record)
          send_data pdf.render, RentRecordPdf.pdf_config(@item.id, @rent_record.id)
        end
      end
    else
      respond_to do |format|
        format.html do
          ( request.xhr? ) ? render(text: '您沒有權限') : redirect_with_message(item_path(@item))
        end
        format.pdf { redirect_with_message(item_path(@item)) }
      end
    end
  end

  def new
    @rent_record = @item.rent_records.build
    set_start_and_end_params
  end

  def create
    @rent_record = @item.rent_records.build(rent_record_params)
    @rent_record.borrower = current_user

    if @rent_record.save
      @rent_record.lender.notify @rent_record.notify_booking_subject, item_rent_record_url(@item, @rent_record)
      redirect_to item_rent_record_path(@item, @rent_record)
    else
      flash[:alert] = '請檢查紅字錯誤欄位'
      render :new
    end
  end

  def review
    if @rent_record.can_review_by?(current_user)
      @review = @rent_record.reviews.build
      render "reviews/new"
    else
      redirect_with_message( item_path(@item) )
    end
  end

  def ask_for_review
    if @rent_record.is_reviewed_by_judger?(current_user)
      review = @rent_record.review_of_judger(current_user)
      review.user.notify review.notify_ask_for_review_subject, review_item_rent_record_url(@item, @rent_record)
      redirect_with_message :back, notice: '邀請評價通知已寄送'
    else
      redirect_with_message review_item_rent_record_path(@item, @rent_record), notice: '請您先行評價'
    end
  end

  def remitting
    if @rent_record.can_remit_by?(current_user)
      if @rent_record.remit!(current_user, rent_record_state_log_params)
        redirect_to item_rent_record_path(@item, @rent_record)
      else
        @rent_record_state_logs = @rent_record.rent_record_state_logs
        @rent_record_state_log = @rent_record_state_logs.last
        flash[:alert] = '請檢查匯款帳號資訊'
        render :show
      end
    end
  end

  def delivering
    @rent_record.delivery!(current_user, rent_record_state_log_params) if @rent_record.can_delivery_by?(current_user)
    redirect_to :back
  end

  def renting
    @rent_record.rent!(current_user, rent_record_state_log_params) if @rent_record.can_rent_by?(current_user)
    redirect_to :back
  end

  def returning
    @rent_record.return!( current_user ) if @rent_record.can_return_by?(current_user)
    redirect_to :back
  end

  def withdrawing
    @rent_record.withdraw!( current_user ) if @rent_record.can_withdraw_by?(current_user)
    redirect_to :back
  end

  private

  def rent_record_params
    params.require(:rent_record).permit(
      :name, :phone, :deliver_id,
      :started_at, :ended_at
    )
  end

  def rent_record_state_log_params
    params.require(:rent_record_state_log).permit(
      :info, attachments_attributes: [ :public_id, :file_cached ]
    )
  end

  def find_item
    @item = Item.find(params[:item_id])
  end

  def validates_item_rentable
    redirect_with_message(item_path(@item)) unless @item.rentable_by?(current_user)
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
