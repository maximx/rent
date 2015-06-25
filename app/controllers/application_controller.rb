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

  def set_item_maps_marker
    @maps = Gmaps4rails.build_markers(@item) do |item, marker|
      marker.lat item.latitude
      marker.lng item.longitude
      marker.infowindow("<h4>#{link_of(item)}</h4><br />#{item.address}")
      marker.json({ title: item.name })
    end
  end

  def link_of(item)
    view_context.link_to( item.name, item_url(item) )
  end

end
