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
    meta_prev_page_link(collection)
    meta_next_page_link(collection)
  end

  def meta_prev_page_link(collection)
    if collection.previous_page
      url_params = params.merge(page: collection.previous_page, only_path: false)
      url_params.delete(:page) if collection.previous_page == 1
      set_meta_tags prev: url_for(url_params)
    end
  end

  def meta_next_page_link(collection)
    if collection.next_page
      url_params = params.merge(page: collection.next_page, only_path: false)
      set_meta_tags next: url_for(url_params)
    end
  end
end
