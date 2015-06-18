module ItemsHelper

  def render_collect_item_link(item)
    if current_user && current_user.is_collected?(item)
       link_to("取消收藏", uncollect_item_path(item), method: :delete, class: "btn btn-default")
    else
       link_to("收藏", collect_item_path(item), method: :post, class: "btn btn-info")
    end
  end

  def render_item_index_breadcrumbs
    case params[:controller]
    when "categories"
      breadcrumb :category, @category
    when "subcategories"
      breadcrumb :subcategory, @subcategory
    end
  end

end
