module Account::SettingsHelper
  def settings_navbar_list
    render_link_li class: 'nav navbar-nav' do |li|
      li << [ render_icon_with_text('lock', t('controller.account/settings.action.show')),
              account_settings_path ]
      li << [ render_icon_with_text('wrench', t('controller.account/settings.action.preferences')),
              preferences_account_settings_path ]
    end
  end

  def account_settings_controller?
     params[:controller] == 'account/settings'
  end
end
