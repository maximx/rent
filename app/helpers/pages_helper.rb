module PagesHelper
  def render_root_navbar_class
    default_class = pages_index_action? ? '' : ' navbar-fixed-top'
    "navbar navbar-default " + default_class
  end

  def pages_index_action?
    params[:controller] == 'pages' and params[:action] == 'index'
  end
end
