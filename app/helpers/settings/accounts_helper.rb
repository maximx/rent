module Settings::AccountsHelper
  def settings_account_related_controller?
    ['profiles', 'settings/accounts'].include?(params[:controller])
  end

  def settings_navbar_list
    render_link_li class: 'nav navbar-nav' do |li|
      li << [ render_icon_with_text('user', '基本資料'), settings_account_path ]
      li << [ render_icon_with_text('lock', '帳戶設定'), edit_settings_account_path ]
    end
  end
end
