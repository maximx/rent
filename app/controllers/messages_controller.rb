class MessagesController < ApplicationController
  before_action :login_required
  before_action :find_recipient

  def create
    message = current_user.send_message(@recipient, message_params[:body], subject)
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
