class Dashboard::RentRecordsController < ApplicationController
  before_action :login_required
  before_action :find_item, only: [ :index, :new, :create ]

  def index
    @rent_records = if find_item?
                      @item.rent_records.actived.rencent.page(params[:page])
                    else
                      current_user.borrow_records.includes(:item).rencent.page(params[:page])
                    end

    @rent_record_state_log = unless @rent_records.empty?
                               @rent_records.first.rent_record_state_logs.build
                             else
                               RentRecordStateLog.new
                             end
    render (find_item? ? :item_index : :index)
  end

  def new
    @event_sources_path = calendar_item_path(@item, format: :json)
    @rent_record = @item.rent_records.build
    @disabled_dates = @item.booked_dates

    render 'rent_records/new'
  end

  def create
    @rent_record = @item.rent_records.build rent_record_params
    @rent_record.deliver = Deliver.face_to_face

    customer = current_user.customers.find @rent_record.borrower_id
    @rent_record.borrower = customer

    if @rent_record.save
      redirect_to item_rent_record_path(@item, @rent_record)
    else
      flash[:alert] = '請檢查紅字錯誤欄位'
      render :new
    end
  end

  def calendar
    @event_sources_path = calendar_dashboard_rent_records_path(format: :json, role: params[:role])
    rent_records_json = if params[:role] == "borrower"
                          current_user.borrow_records.includes(:borrower)
                            .overlaps(params[:start], params[:end]).to_json
                        else
                          current_user.lend_records.includes(:borrower)
                            .overlaps(params[:start], params[:end]).to_json
                        end

    respond_to do |format|
      format.html { render :calendar }
      format.json { render json: rent_records_json }
    end
  end

  private

    def rent_record_params
      params.require(:rent_record).permit(:borrower_id, :borrower_type, :started_at, :ended_at)
    end

    def find_item
      @item = current_user.items.find params[:item_id] if find_item?
    end

    def find_item?
      !view_context.current_page? dashboard_rent_records_path
    end
end
