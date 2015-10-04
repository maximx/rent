class QuestionsController < ApplicationController
  before_action :login_required, only: [ :create, :update, :destroy ]
  before_action :find_item, only: [ :create, :update, :destroy ]
  before_action :find_question, only: [ :update, :destroy ]

  def create
    @question = @item.questions.build(question_params)
    @question.asker = current_user

    if @question.save
      QuestionMailer.notify_question(@question).deliver
      redirect_with_message item_path(@item), notice: '已成功提問'
    end
  end

  def update
    if @question.update(question_params)
      QuestionMailer.notify_question_reply(@question).deliver
      redirect_with_message item_path(@item), notice: '已成功回覆'
    end
  end

  def destroy
    @question.destroy
    redirect_with_message items_path, notice: '已成功刪除'
  end


  private

    def question_params
      params.require(:question).permit(:content, :reply)
    end

    def find_item
      @item = Item.find(params[:item_id])
    end

    def find_question
      @question = @item.questions.find(params[:id])
    end
end
