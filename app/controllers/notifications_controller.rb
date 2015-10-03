class NotificationsController < ApplicationController
  before_action :login_required
  before_action :find_mailbox
  before_action :find_notification, only: [ :show, :mark_as_read ]

  def index
    @notifications = @mailbox.notifications(unread: true)
  end

  def show
    if request.xhr?
      @notification.mark_as_read(current_user)
      respond_to do |format|
        format.json { render json: @notification }
      end
    end
  end

  def mark_as_read
    result = { status: 'error' }

    if request.xhr?
      @notification.mark_as_read(current_user)
      result = { status: 'ok' }
    end

    respond_to do |format|
      format.json { render json: result }
    end
  end

  private

    def find_mailbox
      @mailbox = current_user.mailbox
    end

    def find_notification
      @notification = @mailbox.notifications.find params[:id]
    end
end
