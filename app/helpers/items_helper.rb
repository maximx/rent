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

  def render_items_view_links
    links = []
    current_view = ( ['list', 'grid'].include?(params[:view]) ) ? params[:view] : 'grid'

    ['list', 'th-large'].each do |type|
      link_view = (type == 'list') ? type : 'grid'
      css_class = 'btn btn-default view-type'
      css_class += ' active' if link_view == current_view
      links << link_to( render_icon(type),
                        params.merge(view: link_view),
                        class: css_class, role: 'botton', data: { view: link_view } )
    end

    raw links.join
  end

  def render_item_index_breadcrumbs(obj = {})
    case params[:controller]
    when "categories"
      breadcrumb :category, obj
    when "subcategories"
      breadcrumb :subcategory, obj
    end
  end

  def render_user_reviews(user, total_count)
    output = []
    Review.rates.slice(:good, :bad).keys.each do |type|
      output << render_user_review(user, total_count, type)
    end
    output.join(" ")
  end

  def render_user_review(user, total_count, type)
    text = Review.human_attribute_name("rate.#{type}")
    count = (total_count && !total_count.empty?) ?
      (total_count[ [user.id, Review.rates[type] ] ] || 0) : 0
    "#{text}∶#{count}"
  end

  def render_new_rent_record_link(item)
    if new_rent_record_button_display?(item)
      link_to(render_icon_with_text("paperclip", "預約承租"), new_item_rent_record_path(item), class: "btn btn-default")
    end
  end

  def render_item_view
    view ||= 'grid'
    view = params[:view] if ['list', 'grid'].include? params[:view]
    view
  end

  def render_item_name(item, length = 20)
    truncate item.name, length: length
  end

  def render_price_min
    ( params[:price_min].present? ) ? params[:price_min].to_i : Item::PRICE_MIN
  end

  def render_price_max
    ( params[:price_max].present? ) ? params[:price_max].to_i : Item::PRICE_MAX
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

  def items_related_controller?
    ['items', 'categories', 'subcategories', 'rent_records'].include?(params[:controller])
  end

  #items sort type
  def items_sort_order_list
    {
      '最新物品': params.delete_if { |key| ['sort', 'order'].include? key },
      '最高價格': params.merge(sort: 'price', order: 'desc'),
      '最低價格': params.merge(sort: 'price').delete_if { |key| key == 'order' }
    }
  end
end
