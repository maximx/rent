class ConversationsController < ApplicationController
  before_action :login_required
  before_action :find_mailbox
  before_action :find_conversation, except: [ :index, :unread ]

  def index
    @conversations = @mailbox.inbox
  end

  def unread
    @conversations = @mailbox.inbox(unread: true)
    render :index
  end

  def show
    @conversation.mark_as_read(current_user)
  end

  def reply
    current_user.reply_to_conversation(@conversation, params[:message][:body])
    flash[:notice] = '成功回覆訊息'
    redirect_to conversation_path(@conversation)
  end

  def mark_as_read
    result = { status: 'error' }

    if request.xhr?
      @conversation.mark_as_read(current_user)
      result = { status: 'ok' }
    end

    respond_to do |format|
      format.json { render json: result }
    end
  end

  def destroy
    @conversation.move_to_trash(current_user)
    flash[:notice] = '已成功刪除交談紀錄'
    redirect_to conversations_path
  end

  private

    def find_mailbox
      @mailbox = current_user.mailbox
    end

    def find_conversation
      @conversation = @mailbox.inbox.find(params[:id])
    end
end
