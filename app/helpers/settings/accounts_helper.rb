module Settings::AccountsHelper
  def settings_page?
    "profiles" == params[:controller] || params[:controller].start_with?("settings")
  end

  def settings_account_related_controller?
    ['profiles', 'settings/account'].include?(params[:controller])
  end
end
