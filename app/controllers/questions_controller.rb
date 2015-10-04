class QuestionsController < ApplicationController
  before_action :login_required, only: [ :create, :update, :destroy ]
  before_action :find_item, only: [ :create, :update, :destroy ]
  before_action :find_question, only: [ :update, :destroy ]

  def create
    @question = @item.questions.build(question_params)
    @question.asker = current_user

    if @question.save
      QuestionMailer.notify_question(@question).deliver
      flash[:notice] = '已成功提問'
      redirect_to item_path(@item)
    end
  end

  def update
    if @question.update(question_params)
      QuestionMailer.notify_question_reply(@question).deliver
      flash[:notice] = '已成功回覆'
      redirect_to item_path(@item)
    end
  end

  def destroy
    @question.destroy
    redirect_to items_path
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
