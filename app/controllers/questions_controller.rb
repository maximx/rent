class QuestionsController < ApplicationController
  before_action :login_required, only: [ :create, :update, :destroy ]
  before_action :find_item, only: [ :create, :update, :destroy ]

  def create
    @question = @item.questions.build(question_params)
    @question.asker = current_user
    @question.save

    redirect_to item_path(@item)
  end

  def update
  end

  def destroy
  end

  private

  def question_params
    params.require(:question).permit(:content, :reply)
  end

  def find_item
    @item = Item.find(params[:item_id])
  end
end
