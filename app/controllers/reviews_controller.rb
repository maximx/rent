class ReviewsController < ApplicationController
  before_action :login_required, only: [ :create ]
  before_action :find_item, only: [ :create ]
  before_action :find_record, only: [ :create ]

  def create
    @review = current_user.revieweds.build(review_params)
    @review.record = @record

    if @review.save
      redirect_to item_record_path(@item, @record)
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

  def find_record
    @record = @item.records.find(params[:record_id])
  end

end
