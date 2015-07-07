module ItemsHelper

  def render_collect_item_link(item)
    if current_user && current_user.is_collected?(item) && collect_rent_display?
       link_to("取消收藏", uncollect_item_path(item), method: :delete, class: "btn btn-default")
    elsif collect_rent_display?
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

  def rent_record_button_display?(item)
    current_user != item.lender && collect_rent_display?
  end

  def collect_rent_display?
    !["review", "index"].include?(params[:action])
  end

  def render_users_reviews(user, good_or_bad, total_count)
    total_count[ [user.id, Review.rates[good_or_bad] ] ] || 0
  end

end
