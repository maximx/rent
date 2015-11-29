module ToursHelper
  def render_next_path
    user_signed_in? ? tours_path : new_user_registration_path
  end
end
