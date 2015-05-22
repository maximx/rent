class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def login_required
    if current_user.blank?
      respond_to do |format|
        format.html { authenticate_user! }
        format.all { head(:unauthorized) }
      end
    end
  end
end
