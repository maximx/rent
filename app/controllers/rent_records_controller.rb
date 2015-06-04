class RentRecordsController < ApplicationController
  before_action :login_required, except: [ :index ]
  before_action :find_item
  before_action :find_user_rent_record, only: [ :edit, :update, :destroy ]
  before_action :find_item_rent_record, only: [ :show, :review, :renting, :returning ]

  def index
  end

  def show
    if @rent_record.viewable_by?(current_user)
      respond_to do |format|
        format.html
        format.pdf do
          pdf = RentRecordPdf.new(@rent_record)

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
    else
      redirect_to item_path(@item)
    end
  end

  def create
    @rent_record = @item.rent_records.build(rent_record_params)
    @rent_record.borrower = current_user

    if @rent_record.save
      redirect_to item_rent_records_path
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
    @review = @rent_record.build_review
    render "reviews/new"
  end

  def renting
    @rent_record.rent! if @rent_record.can_rent_by?(current_user)
    redirect_to item_rent_records_path(@item)
  end

  def returning
    @rent_record.return! if @rent_record.can_return_by?(current_user)
    redirect_to item_rent_records_path(@item)
  end

  private

  def rent_record_params
    params.require(:rent_record).permit(
      :name, :email, :phone,
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
end
