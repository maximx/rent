module Settings::AccountsHelper
  def settings_navbar_list
    render_link_li class: 'nav navbar-nav' do |li|
      li << [ render_icon_with_text('lock', t('controller.settings/account.edit')), edit_settings_account_path ]
      li << [ render_icon_with_text('wrench', t('controller.settings/account.show')), settings_account_path ]
    end
  end

  def settings_account_controller?
     params[:controller] == 'settings/accounts'
  end

  def settings_account_related_controller?
    settings_account_controller? or profiles_controller?
  end
end
