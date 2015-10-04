class ReviewsController < ApplicationController
  before_action :login_required, only: [ :create ]
  before_action :find_item, only: [ :create ]
  before_action :find_rent_record, only: [ :create ]

  def create
    @review = current_user.revieweds.build(review_params)
    @review.rent_record = @rent_record

    if @review.save
      redirect_to item_rent_record_path(@item, @rent_record)
    else
      render :new
    end
  end

  private

  def review_params
    params.require(:review).permit(:content, :rate)
  end

  def find_item
    @item = Item.find(params[:item_id])
  end

  def find_rent_record
    @rent_record = @item.rent_records.find(params[:rent_record_id])
  end

end
