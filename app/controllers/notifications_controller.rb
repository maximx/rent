class NotificationsController < ApplicationController
  before_action :login_required
  before_action :find_mailbox
  before_action :find_notification, only: [ :show, :mark_as_read ]
  before_action :set_title_meta_tag

  def index
    @notifications = @mailbox.notifications
  end

  def show
    @notification.mark_as_read(current_user)
    redirect_to @notification.body
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
