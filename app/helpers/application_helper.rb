module ApplicationHelper
  def render_categories_aside
    if ["items", "categories", "subcategories"].include?(params[:controller])
      render partial: "layouts/category"
    end
  end
end
