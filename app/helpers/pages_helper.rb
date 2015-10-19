module PagesHelper
  def pages_index_action?
    params[:controller] == 'pages' and params[:action] == 'index'
  end
end
