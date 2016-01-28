class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include CanCan::ControllerAdditions
  include SetCommonMetaTag

  layout proc { false if request.xhr? }

  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_url = request.referer.present? ? :back : items_path
    unless request.xhr?
      redirect_to redirect_url, alert: t('common.no_privilege')
    else
      render text: t('common.no_privilege')
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:account, :email, :password, :password_confirmation, :remember_me, :agreement)
    end

    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :account, :email, :password, :remember_me) }

    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:account, :email, :password, :password_confirmation, :current_password)
    end
  end

  def login_required
    authenticate_user! unless user_signed_in?
  end

  def set_maps_marker(object)
    @maps = Gmaps4rails.build_markers(object) do |obj, marker|
      google_url = "http://maps.google.com/maps?q=#{obj.address}"
      info = [
        "<h4>#{obj.name}</h4>",
        obj.address,
        view_context.link_to('詳細', google_url, target: '_blank')
      ]

      marker.lat obj.latitude
      marker.lng obj.longitude
      marker.infowindow info.join("<br />")
      marker.json({ title: obj.name })
    end

    @maps.delete_if { |marker| marker[:lat].nil? || marker[:lng].nil? }
  end

  def load_shopping_cart
    shopping_cart_id = session[:shopping_cart_id]
    @shopping_cart = shopping_cart_id.present? ? ShoppingCart.find(shopping_cart_id) : ShoppingCart.create
    session[:shopping_cart_id] = @shopping_cart.id
  end

  def load_customer_shopping_cart
    @shopping_cart = @customer.shopping_cart
    @shopping_cart = @customer.create_shopping_cart unless @shopping_cart
  end
end
