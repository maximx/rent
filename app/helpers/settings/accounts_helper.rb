module Settings::AccountsHelper
  def settings_page?
    "profiles" == params[:controller] || params[:controller].start_with?("settings")
  end
end
