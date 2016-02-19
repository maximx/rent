class RecordsController < ApplicationController
  before_action :login_required, except: [ :index ]
  load_and_authorize_resource :item
  load_and_authorize_resource :record, through: :item, except: [ :index ]
  before_action :validates_borrower_info, only: [:new, :create]
  before_action :set_calendar_event_sources_path, :find_disabled_dates, only: [ :index, :new, :create ]

  before_action ->{ set_title_meta_tag suffix: @item.name }, only: [:index, :new, :create]
  before_action only: [:show] do
    set_title_meta_tag suffix: "#{t('controller.records.action.index')}##{@record.id}"
  end

  def index
    @records = @item.records.includes(:borrower).recent.reverse_order.page(params[:page])
  end

  def show
    if request.xhr?
      render('records/show_popover')
    else
      @sibling_records = @record.sibling_records
      @order_lender = @record.order_lender
      set_maps_marker(@record)
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

  private
    def record_params
      params.require(:record).permit(:deliver_id, :started_at, :ended_at, :send_period)
    end

    def validates_borrower_info
      if @record.borrower_info_needed?
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
