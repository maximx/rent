module Account::SettingsHelper
  def account_settings_navbar_list
    render_link_li class: 'nav navbar-nav' do |li|
      li << [t('controller.account/settings.action.show'), account_settings_path]
      li << [t('controller.account/settings.action.preferences'), preferences_account_settings_path]
      li << [t('controller.account/settings.action.lender'), lender_account_settings_path]
    end
  end

  def account_settings_controller?
     controller_path == 'account/settings'
  end
end
