class QuestionsController < ApplicationController
  before_action :login_required, only: [ :create, :update, :destroy ]
  before_action :find_item, only: [ :create, :update, :destroy ]
  before_action :find_question, only: [ :update, :destroy ]

  def create
    @question = @item.questions.build(question_params)
    @question.asker = current_user

    if @question.save
      subject = "#{current_user.account}詢問#{@item.name}，請您回覆"
      @question.item.lender.notify subject, item_path(@item)
      redirect_with_message item_path(@item), notice: '已成功提問'
    end
  end

  def update
    if @question.update(question_params)
      subject = "#{current_user.account}已回覆#{@item.name}的問題，請檢視"
      @question.asker.notify subject, item_path(@item)
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
