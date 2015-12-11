class ReviewsController < ApplicationController
  before_action :login_required
  load_and_authorize_resource :item
  load_and_authorize_resource :record, through: :item
  load_and_authorize_resource :review, through: :record

  def new
  end

  def create
    @review.judger = current_user

    if @review.save
      redirect_to item_record_path(@item, @record)
    else
      flash[:alert] = t('controller.action.create.fail')
      render :new
    end
  end

  private
    def review_params
      params.require(:review).permit(:content, :rate)
    end
end
