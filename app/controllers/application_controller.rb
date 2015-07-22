class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def login_required
    authenticate_user! unless user_signed_in?
  end

  def find_navbar_categories
    @categories = Category.includes(:subcategories).all
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

  def meta_pagination_links(collection)
    if collection.previous_page
      set_meta_tags prev: url_for(params.merge(page: collection.previous_page, :only_path => false))
    end
    if collection.next_page
      set_meta_tags next: url_for(params.merge(page: collection.next_page, :only_path => false))
    end
  end
end
