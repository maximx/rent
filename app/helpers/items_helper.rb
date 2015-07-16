module ItemsHelper

  def render_collect_item_links(item, type = "")
    if uncollect_link_display?(item)
      render_uncollect_item_link(item, type)
    elsif collect_rent_display?
      render_collect_item_link(item, type)
    end
  end

  def render_uncollect_item_link(item, type = "")
    if is_remote?(type)
      link_to(render_icon("bookmark"), uncollect_item_path(item, format: :json),
              remote: is_remote?(type), method: :delete, class: "btn btn-danger item-bookmark")
    else
      link_to("取消收藏", uncollect_item_path(item), method: :delete, class: "btn btn-default")
    end
  end

  def render_collect_item_link(item, type = "")
    if is_remote?(type)
      link_to(render_icon("bookmark"), collect_item_path(item, format: :json),
              remote: is_remote?(type), method: :post, class: "btn btn-default item-bookmark")
    else
      link_to("收藏", collect_item_path(item), method: :post, class: "btn btn-primary item-bookmark")
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

  def rent_record_button_display?(item)
    current_user != item.lender && collect_rent_display?
  end

  def collect_rent_display?
    !["review"].include?(params[:action])
  end

  def render_user_reviews(user, good_or_bad, total_count)
    if total_count && !total_count.empty?
      total_count[ [user.id, Review.rates[good_or_bad] ] ] || 0
    else
      0
    end
  end

  private

    def uncollect_link_display?(item)
     ( current_user && current_user.is_collected?(item) && collect_rent_display? )
    end

end
