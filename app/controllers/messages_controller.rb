class MessagesController < ApplicationController
  before_action :login_required
  before_action :find_recipient

  def create
    result = { status: 'error' }
    if request.xhr?
      message = current_user.send_message(@recipient, message_params[:body], subject)
      if message.id
        result = { status: 'ok', message: '成功送出訊息' }
      elsif message_params[:body].blank?
        result[:message] = '<code>請填寫訊息內容</code>'
      end
    end

    respond_to do |format|
      format.json { render json: result }
    end
  end

  private

    def message_params
      params.require(:message).permit(:recipient, :body)
    end

    def find_recipient
      @recipient = User.find(message_params[:recipient])
    end

    def subject
      "這是#{current_user.account}發送給您的訊息"
    end
end
