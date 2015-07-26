module ItemsHelper

  def render_collect_item_links(item, type = "")
    if uncollect_link_display?(item)
      render_uncollect_item_link(item, type)
    elsif item_action_display?
      render_collect_item_link(item, type)
    end
  end

  def render_uncollect_item_link(item, type = "")
    icon = "bookmark"
    if is_remote?(type)
      link_to(render_icon( icon ), uncollect_item_path(item, format: :json),
              remote: is_remote?(type), method: :delete, class: "btn btn-danger item-bookmark")
    else
      link_to(render_icon_with_text(icon, "取消收藏"), uncollect_item_path(item),
              method: :delete, class: "btn btn-default")
    end
  end

  def render_collect_item_link(item, type = "")
    icon = "bookmark"
    if is_remote?(type)
      link_to(render_icon( icon ), collect_item_path(item, format: :json),
              remote: is_remote?(type), method: :post, class: "btn btn-default item-bookmark")
    else
      link_to(render_icon_with_text(icon, "收藏"), collect_item_path(item),
              method: :post, class: "btn btn-default item-bookmark")
    end
  end

  def render_item_index_breadcrumbs(obj = {})
    case params[:controller]
    when "categories"
      breadcrumb :category, obj
    when "subcategories"
      breadcrumb :subcategory, obj
    end
  end

  def render_user_reviews(user, good_or_bad, total_count)
    if total_count && !total_count.empty?
      total_count[ [user.id, Review.rates[good_or_bad] ] ] || 0
    else
      0
    end
  end

  def render_new_rent_record_link(item)
    if new_rent_record_button_display?(item)
      link_to(render_icon_with_text("paperclip", "預約承租"), new_item_rent_record_path(item), class: "btn btn-default")
    end
  end

  def new_rent_record_button_display?(item)
    (!user_signed_in? || item.rentable_by?(current_user) ) && item_action_display?
  end

  def item_action_display?
    !["review"].include?(params[:action])
  end

  def uncollect_link_display?(item)
    user_signed_in? && current_user.is_collected?(item) && item_action_display?
  end

end
