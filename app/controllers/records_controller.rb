class RecordsController < ApplicationController
  before_action :login_required, except: [ :index ]
  load_and_authorize_resource :item
  load_and_authorize_resource :record, through: :item, except: [ :index ]
  before_action :validates_borrower_info, only: [ :new, :create ]
  before_action :set_calendar_event_sources_path, :find_disabled_dates, only: [ :index, :new, :create ]

  def index
    @records = @item.records.includes(:borrower).recent.reverse_order.page(params[:page])
  end

  def show
    respond_to do |format|
      format.html do
        if request.xhr?
          render('records/show_popover')
        else
          @sibling_records = @record.sibling_records
          @record_state_logs = @record.record_state_logs
          @record_state_log = @record_state_logs.build
        end
      end
      format.pdf do
        pdf = RecordPdf.new(@item, @record)
        send_data pdf.render, RecordPdf.pdf_config(@item.id, @record.id)
      end
    end
  end

  def new
    set_start_and_end_params
  end

  def create
    @record.borrower = current_user

    if @record.save
      @record.update_order
      @record.lender.notify @record.notify_booking_subject, item_record_url(@item, @record)
      redirect_to item_record_path(@item, @record)
    else
      @record.ended_at = @record.ended_date
      flash[:alert] = t('controller.action.create.fail')
      render :new
    end
  end

  def ask_for_review
    review = @record.review_of_judger(current_user)
    review.user.notify review.notify_ask_for_review_subject, new_item_record_review_url(@item, @record)
    redirect_to :back, notice: t('helpers.records.ask_for_review_send')
  end

  def remitting
    if @record.remit!(current_user, record_state_log_params)
      if params[:batch]
        @record.sibling_records.each {|record| record.remit!(current_user, record_state_log_params) if record.may_remit?}
        redirect_to borrower_order_path(@record.order) and return
      end
      redirect_to item_record_path(@item, @record)
    else
      @record_state_logs = @record.record_state_logs
      @record_state_log = @record_state_logs.last
      flash[:alert] = t('controller.records.remitting.fail')
      render :show
    end
  end

  def delivering
    @record.delivery!(current_user, record_state_log_params)
    if params[:batch]
      @record.sibling_records.each {|record| record.delivery!(current_user, record_state_log_params) if record.may_delivery?}
    end
    redirect_to :back
  end

  def renting
    @record.rent!(current_user, record_state_log_params)
    if params[:batch]
      @record.sibling_records.each {|record| record.rent!(current_user, record_state_log_params) if record.may_rent?}
    end
    redirect_to :back
  end

  def returning
    @record.return! current_user
    if params[:batch]
      @record.sibling_records.each {|record| record.return!(current_user, record_state_log_params) if record.may_return?}
    end
    redirect_to :back
  end

  def withdrawing
    @record.withdraw! current_user
    if params[:batch]
      @record.sibling_records.each {|record| record.withdraw!(current_user, record_state_log_params)}
    end
    redirect_to :back
  end

  private
    def record_params
      params.require(:record).permit(:deliver_id, :started_at, :ended_at, :send_period)
    end

    def record_state_log_params
      if params.has_key? :record_state_log
        params.require(:record_state_log).permit(:info, attachments: [])
      else
        { }
      end
    end

    def validates_borrower_info
      if @item.lender.borrower_info_provide
        errors = current_user.profile.validates_detail_info
        unless errors.empty?
          redirect_to edit_user_path(current_user, redirect_url: new_item_record_path(@item)),
                      alert: t('activerecord.errors.models.profile.attributes.info.blank', attrs: errors.join('、'))
        end
      end
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
