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

  def find_aside_categories
    @categories = Category.includes(:subcategories).all
  end

  def set_category_and_subcategory(id = [])
    @category_id = id[0]
    @subcategory_id = id[1] if id[1]
  end

end
