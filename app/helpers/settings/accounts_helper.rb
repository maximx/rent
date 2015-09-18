module Settings::AccountsHelper
  def settings_account_related_controller?
    ['profiles', 'settings/accounts'].include?(params[:controller])
  end
end
