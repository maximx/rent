module ItemsHelper

  def render_collect_item_link(item)
    if current_user && current_user.is_collected?(item) && collect_rent_display?
       link_to("取消收藏", uncollect_item_path(item), method: :delete, class: "btn btn-default")
    elsif collect_rent_display?
       link_to("收藏", collect_item_path(item), method: :post, class: "btn btn-info")
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
      total_count[ [user.id, Review.rates[good_or_bad] ] ]
    else
      0
    end
  end

end
