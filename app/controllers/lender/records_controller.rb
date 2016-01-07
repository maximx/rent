class Lender::RecordsController < ApplicationController
  before_action :login_required
  load_and_authorize_resource :item, through: :current_user

  def new
    @event_sources_path = calendar_item_path(@item, format: :json)
    @record = @item.records.build
    @disabled_dates = @item.booked_dates
  end

  def create
    @record = @item.records.build record_params

    @record.deliver = Deliver.face_to_face
    @record.borrower_type = 'Customer'

    if @record.save
      @record.update_order
      redirect_to item_record_path(@item, @record)
    else
      @disabled_dates = @item.booked_dates
      flash[:alert] = t('controller.action.create.fail')
      render 'records/new'
    end
  end

  private
    def record_params
      params.require(:record).permit(:borrower_id, :started_at, :ended_at)
    end
end
