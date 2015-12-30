class Account::RecordsController < ApplicationController
  before_action :login_required
  load_and_authorize_resource :item, through: :current_user, only: [ :new, :create ]

  def index
    @records = current_user.records
                           .includes(:borrower, :deliver, [item: [lender: [profile: :avatar]]])
                           .recent
                           .page(params[:page])
    @record_state_log = unless @records.empty?
                          @records.first.record_state_logs.build
                        else
                          RecordStateLog.new
                        end
  end

  def new
    @event_sources_path = calendar_item_path(@item, format: :json)
    @record = @item.records.build
    @disabled_dates = @item.booked_dates

    render 'records/new'
  end

  def create
    @record = @item.records.build record_params

    @record.deliver = Deliver.face_to_face
    #TODO: customers 放到 model validate
    customer = current_user.customers.find @record.borrower_id
    @record.borrower = customer

    if @record.save
      redirect_to item_record_path(@item, @record)
    else
      flash[:alert] = t('controller.action.create.fail')
      render 'records/new'
    end
  end

  def calendar
    @event_sources_path = calendar_account_records_path(format: :json)

    respond_to do |format|
      format.html
      format.json {
        records_json = current_user.orders
                                   .includes(borrower: :profile)
                                   .overlaps(params[:start], params[:end])
                                   .to_json
        render json: records_json
      }
    end
  end

  private
    def record_params
      params.require(:record).permit(:borrower_id, :started_at, :ended_at)
    end
end
