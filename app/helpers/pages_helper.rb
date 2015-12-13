module PagesHelper
  def pages_navbar_list
    render_link_li class: 'nav navbar-nav footer-links' do |li|
      li << [ t('controller.pages.action.about'), about_path ]
      li << [ t('controller.pages.action.terms'), terms_path ]
      li << [ t('controller.pages.action.privacy'), privacy_path ]
      li << [ t('controller.pages.action.contact'), contact_path ]
    end
  end

  def pages_index_action?
    controller_path == 'pages' and action_name == 'index'
  end

  def pages_controller?
    controller_path == 'pages'
  end
end
