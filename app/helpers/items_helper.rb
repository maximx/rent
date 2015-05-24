module ItemsHelper
  def render_collect_link(item)
    if current_user && current_user.is_collected?(item)
       collect_link = link_to("取消收藏", uncollect_item_path(item), method: :delete)
    else
       collect_link = link_to("收藏", collect_item_path(item), method: :post)
    end

    return collect_link
  end
end
