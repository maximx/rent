class ConversationsController < ApplicationController
  before_action :login_required
  before_action :find_mailbox

  def index
    @conversations = @mailbox.inbox
  end

  private

    def find_mailbox
      @mailbox = current_user.mailbox
    end
end
