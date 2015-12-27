module ItemsHelper
  #users/items 與 items/search 共用
  def render_items_search_path
    if users_controller? and params[:account].present?
      items_user_path(params[:account])
    else
      search_items_path
    end
  end

  def render_collect_item_link(item)
    if can? :collect, item
      link_to render_icon('bookmark'),
              collect_item_path(item, format: :json),
              remote: true, method: :post, class: 'btn btn-default item-bookmark',
              title: t('controller.items.action.collect'), data: { toggle: 'tooltip' }
    end
  end

  def render_uncollect_item_link(item)
    if can? :uncollect, item
      link_to render_icon('bookmark'),
              uncollect_item_path(item, format: :json),
              remote: true, method: :delete, class: 'btn btn-danger item-bookmark',
              title: t('controller.items.action.uncollect'), data: { toggle: 'tooltip' }
    end
  end

  def render_item_calendar_link(item)
    url = can?(:update, item) ?
            account_item_records_path(item, anchor: 'calendar') : new_item_record_path(item, anchor: 'calendar')
    link_to t('helpers.items.see_calendar'), url, class: 'btn btn-info'
  end

  def render_edit_item_link(item)
    if can? :update, item
      link_to render_icon('edit', class: 'text-success'),
              edit_item_path(item),
              target: '_blank',
              class: 'btn btn-default',
              title: t('controller.action.edit'),
              data: { toggle: 'tooltip' }
    end
  end

  def render_destroy_item_link(item)
    if can? :destroy, item
      link_to render_icon('trash', class: 'text-danger'),
              item_path(item),
              class: 'btn btn-default', method: :delete, title: t('controller.action.destroy'),
              data: { toggle: 'tooltip', confirm: t('helpers.items.destroy_confirm', name: item.name) }
    end
  end

  def render_close_item_link(item)
    if can? :close, item
      link_to render_icon('download', class: 'text-danger'),
              close_item_path(item),
              class: 'btn btn-default', method: :patch, title: t('controller.items.action.close'),
              data: { toggle: 'tooltip', confirm: t('helpers.items.close_confirm', name: item.name) }
    end
  end

  def render_open_item_link(item)
    if can? :open, item
      link_to render_icon('upload', class: 'text-success'),
              open_item_path(item),
              class: 'btn btn-default', method: :patch, title: t('controller.items.action.open'),
              data: { toggle: 'tooltip', confirm: t('helpers.items.open_confirm', name: item.name) }
    end
  end

  def render_add_item_link(item)
    link_to '加車',
            add_item_path(item),
            class: 'btn btn-default', method: :post
  end

  def render_remove_item_link(item)
    link_to '移車',
            remove_item_path(item),
            class: 'btn btn-default', method: :delete
  end

  def render_items_view_links
    links = []
    current_view = ( ['list', 'grid'].include?(params[:view]) ) ? params[:view] : 'grid'

    ['list', 'th-large'].each do |type|
      link_view = (type == 'list') ? type : 'grid'
      css_class = 'btn btn-default view-type'
      css_class += ' active' if link_view == current_view
      links << link_to(render_icon(type), '#', class: css_class, role: 'button', data: { view: link_view })
    end

    raw links.join
  end

  def render_item_index_breadcrumbs(obj = {})
    case controller_path
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

  def render_item_view
    view ||= 'grid'
    view = params[:view] if ['list', 'grid'].include? params[:view]
    view
  end

  def render_item_name(item, length = 19)
    truncate item.name, length: length
  end

  def render_price_min
    ( params[:price_min].present? ) ? params[:price_min].to_i : Item::PRICE_MIN
  end

  def render_price_max
    ( params[:price_max].present? ) ? params[:price_max].to_i : Item::PRICE_MAX
  end

  def item_action_display?
    !["review"].include? action_name
  end

  def items_controller?
    controller_path == 'items'
  end

  def items_related_controller?
    ['items', 'categories', 'subcategories', 'records'].include? controller_path
  end

  def render_sort_span
    text = items_sort_order_list.select { |text, options| options[:sort] == params[:sort] }
    #非預設排序，以最新物品表示
    text = (text.empty?) ? items_sort_order_list.keys.first : text.keys.last
    content_tag(:span,
                text,
                class: 'sort-selected',
                data: items_sort_order_list[text])
  end

  #items sort type
  def items_sort_order_list
    sort_hash = {}
    Item.sort_list.each do |sort|
      sort_hash[t("helpers.items.search.sort.#{sort}").to_sym] = { sort: sort }
    end
    sort_hash
  end
end
