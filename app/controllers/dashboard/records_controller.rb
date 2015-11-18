class Dashboard::RecordsController < ApplicationController
  before_action :login_required
  before_action :find_item, only: [ :index, :new, :create ]

  def index
    @event_sources_path = calendar_item_path(@item, format: :json) if find_item?

    @records = if find_item?
                      @item.records.includes(:borrower, :deliver, :item).rencent.page(params[:page])
                    else
                      current_user.borrow_records
                        .includes(:borrower, :deliver, [ item: [ lender: [profile: :avatar] ] ])
                        .rencent.page(params[:page])
                    end

    @record_state_log = unless @records.empty?
                               @records.first.record_state_logs.build
                             else
                               RentRecordStateLog.new
                             end
    render (find_item? ? :item_index : :index)
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

    customer = current_user.customers.find @record.borrower_id
    @record.borrower = customer

    if @record.save
      redirect_to item_record_path(@item, @record)
    else
      flash[:alert] = '請檢查紅字錯誤欄位'
      render :new
    end
  end

  def calendar
    @event_sources_path = calendar_dashboard_records_path(format: :json, role: params[:role])
    records_json = if params[:role] == "borrower"
                          current_user.borrow_records.includes(:borrower, :item)
                            .overlaps(params[:start], params[:end]).to_json
                        else
                          current_user.lend_records.includes(:borrower, :item)
                            .overlaps(params[:start], params[:end]).to_json
                        end

    respond_to do |format|
      format.html { render :calendar }
      format.json { render json: records_json }
    end
  end

  private

    def record_params
      params.require(:record).permit(:borrower_id, :started_at, :ended_at)
    end

    def find_item
      @item = current_user.items.find params[:item_id] if find_item?
    end

    def find_item?
      !view_context.current_page? dashboard_records_path
    end
end
