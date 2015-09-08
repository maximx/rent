class MessagesController < ApplicationController
  before_action :login_required
  before_action :find_recipient

  def create
    message = current_user.send_message(@recipient, message_params[:body])
  end

  private

    def message_params
      params.require(:message).permit(:recipient, :body)
    end

    def find_recipient
      @recipient = User.find(message_params[:recipient])
    end
end
