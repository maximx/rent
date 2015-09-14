class ConversationsController < ApplicationController
  before_action :login_required
  before_action :find_mailbox
  before_action :find_conversation, except: [ :index ]

  def index
    @conversations = @mailbox.inbox
  end

  def show
    @conversation.mark_as_read(current_user)
  end

  private

    def find_mailbox
      @mailbox = current_user.mailbox
    end

    def find_conversation
      @conversation = @mailbox.conversations.find(params[:id])
    end
end
