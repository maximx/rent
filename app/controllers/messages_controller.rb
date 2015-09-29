class MessagesController < ApplicationController
  before_action :login_required
  before_action :find_recipient
  before_action :find_item

  def create
    result = { status: 'error', message: '來源錯誤' } unless request.xhr?
    result = { status: 'error', message: '錯誤的收訊人' } if current_user == @recipient
    result = { status: 'error', message: '請填寫訊息內容' } if message_params[:body].blank?

    unless result
      message = current_user.send_message(@recipient, message_body, subject)
      if message.id
        result = { status: 'ok', message: '成功送出訊息' }
      else
        result = { status: 'error', message: '未知的錯誤，請稍後再試一次' }
      end
    end

    respond_to do |format|
      format.json { render json: result }
    end
  end

  private

    def message_params
      params.require(:message).permit(:recipient, :item_id, :body)
    end

    def find_recipient
      @recipient = User.find(message_params[:recipient])
    end

    def find_item
      @item = Item.find(message_params[:item_id])
    end

    def message_body
      view_context.content_tag(:p, view_context.link_to(@item.name, item_url(@item))) +
        view_context.content_tag(:p, message_params[:body])
    end

    def subject
      "#{current_user.account}向您聯繫(#{@item.name})"
    end
end
