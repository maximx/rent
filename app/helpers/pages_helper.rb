module PagesHelper
  def pages_navbar_list
    render_link_li class: 'nav navbar-nav footer-links' do |li|
      li << [ '關於', about_path ]
      li << [ '服務條款', terms_path ]
      li << [ '隱私權政策', privacy_path ]
    end
  end

  def pages_index_action?
    params[:controller] == 'pages' and params[:action] == 'index'
  end

  def pages_controller?
    params[:controller] == 'pages'
  end
end
