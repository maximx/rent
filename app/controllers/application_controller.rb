class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:account, :email, :password, :password_confirmation, :remember_me)
    end

    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :account, :email, :password, :remember_me) }

    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:account, :email, :password, :password_confirmation, :current_password)
    end
  end

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

    @maps.delete_if { |marker| marker[:lat].nil? || marker[:lng].nil? }
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

  def redirect_with_message(url, msg = '您沒有權限')
    flash[:alert] = msg
    redirect_to url
  end
end
