module Dashboard::ItemsHelper
  def render_item_records_link(item)
    link_to render_icon('list-alt', class: 'text-primary'),
            dashboard_item_records_path(item),
            class: 'btn btn-default rent-records-list', title: '出租紀錄', data: { toggle: 'tooltip' }
  end

  def dashboard_navbar_list
    render_link_li class: 'nav navbar-nav' do |li|
      li << [ render_icon_with_text('th-large', '出租物管理'), dashboard_items_path, parent: true  ]
      li << [ render_icon_with_text('record', '承租紀錄'), dashboard_records_path, parent: true ]
      li << [ render_icon_with_text('user', '客戶管理'), dashboard_customers_path, parent: true ]
    end
  end

  def render_dashboard_items_index_calendar
    render_link_li class: 'nav nav-tabs', role: 'tablist' do |li|
      li << [ render_icon_with_text('list-alt', '出租物列表'), dashboard_items_path ]
      li << [ render_icon_with_text('calendar', '行事曆'), calendar_dashboard_items_path ]
    end
  end

  def render_operate_item_links(item)
    links = raw [
      render_new_item_record_path(item),
      render_item_records_link(item),
      render_edit_item_link(item),
      render_open_item_link(item),
      render_close_item_link(item),
      render_destroy_item_link(item)
    ].join

    content_tag :div, links, class: 'btn-group'
  end

  def render_renting_checkbox(count)
    if count == 1
      render_icon("ok")
    else
      render_icon("unchecked")
    end
  end

  def dashboard_related_controller?
    params[:controller].start_with?('dashboard') && params[:action] != 'wish'
  end
end
