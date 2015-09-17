module ProfilesHelper
  def profiles_controller?
    'profiles' == params[:controller]
  end
end
