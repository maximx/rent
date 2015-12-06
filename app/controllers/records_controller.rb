class RecordsController < ApplicationController
  before_action :login_required, except: [ :index ]
  before_action :find_item
  before_action :validates_item_rentable, :validates_borrower_info, only: [ :new, :create ]
  before_action :find_item_record, only: [ :show, :review, :remitting, :delivering, :renting,
                                                :returning, :withdrawing, :ask_for_review ]
  before_action :set_calendar_event_sources_path, :find_disabled_dates, only: [ :index, :new, :create ]
  before_action :find_navbar_categories

  def index
    @records = @item.records.includes(:borrower).rencent.reverse_order.page(params[:page])
  end

  def show
    if @record.viewable_by?(current_user)
      @record_state_logs = @record.record_state_logs
      @record_state_log = @record_state_logs.build

      respond_to do |format|
        format.html do
          ( request.xhr? ) ? render('records/show_popover', layout: false) : :show
        end
        format.pdf do
          pdf = RecordPdf.new(@item, @record)
          send_data pdf.render, RecordPdf.pdf_config(@item.id, @record.id)
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
    @record = @item.records.build
    set_start_and_end_params
  end

  def create
    @record = @item.records.build(record_params)
    @record.borrower = current_user

    if @record.save
      @record.lender.notify @record.notify_booking_subject, item_record_url(@item, @record)
      redirect_to item_record_path(@item, @record)
    else
      flash[:alert] = '請檢查紅字錯誤欄位'
      render :new
    end
  end

  def review
    if @record.can_review_by?(current_user)
      @review = @record.reviews.build
      render "reviews/new"
    else
      redirect_with_message( item_path(@item) )
    end
  end

  def ask_for_review
    if @record.is_reviewed_by_judger?(current_user)
      review = @record.review_of_judger(current_user)
      review.user.notify review.notify_ask_for_review_subject, review_item_record_url(@item, @record)
      redirect_with_message :back, notice: '邀請評價通知已寄送'
    else
      redirect_with_message review_item_record_path(@item, @record), notice: '請您先行評價'
    end
  end

  def remitting
    if @record.can_remit_by?(current_user)
      if @record.remit!(current_user, record_state_log_params)
        redirect_to item_record_path(@item, @record)
      else
        @record_state_logs = @record.record_state_logs
        @record_state_log = @record_state_logs.last
        flash[:alert] = '請檢查匯款帳號資訊'
        render :show
      end
    end
  end

  def delivering
    @record.delivery!(current_user, record_state_log_params) if @record.can_delivery_by?(current_user)
    redirect_to :back
  end

  def renting
    @record.rent!(current_user, record_state_log_params) if @record.can_rent_by?(current_user)
    redirect_to :back
  end

  def returning
    @record.return!( current_user ) if @record.can_return_by?(current_user)
    redirect_to :back
  end

  def withdrawing
    @record.withdraw!( current_user ) if @record.can_withdraw_by?(current_user)
    redirect_to :back
  end

  private

    def record_params
      params.require(:record).permit(:deliver_id, :started_at, :ended_at)
    end

    def record_state_log_params
      params.require(:record_state_log).permit(:info, attachments: [])
    end

    def find_item
      @item = Item.includes(lender: [profile: :avatar]).find(params[:item_id])
    end

    def validates_item_rentable
      redirect_with_message(item_path(@item)) unless @item.rentable_by?(current_user)
    end

    def validates_borrower_info
      if @item.lender.profile.borrower_info_provide
        errors = current_user.profile.validates_detail_info
        unless errors.empty?
          redirect_with_message edit_user_path(current_user, redirect_url: new_item_record_path(@item)),
                                alert: t('activerecord.errors.models.profile.attributes.info.blank', attrs: errors.join('、'))
        end
      end
    end

    def find_user_record
      @record = current_user.records.find(params[:id])
    end

    def find_item_record
      @record = @item.records
                     .includes(:deliver, :reviews, borrower: [profile: :avatar], record_state_logs: :attachments)
                     .find(params[:id])
    end

    def set_calendar_event_sources_path
      @event_sources_path = calendar_item_path(@item, format: :json)
    end

    def find_disabled_dates
      @disabled_dates = @item.booked_dates
    end

    def set_start_and_end_params
      @record["started_at"] = params[:record_started_at]
      @record["ended_at"] = params[:record_ended_at]
    end
end
