module Dashboard::ItemsHelper
  def render_item_rent_records_link(item)
    link_to render_icon('list-alt', class: 'text-primary'),
            rent_records_dashboard_item_path(item),
            class: 'btn btn-default rent-records-list', title: '出租紀錄', data: { toggle: 'tooltip' }
  end

  def dashboard_navbar_list
    render_link_li class: 'nav navbar-nav' do |li|
      li << [ render_icon_with_text('list', '出租物管理'), dashboard_items_path ]
      li << [ render_icon_with_text('user', '客戶管理'), dashboard_customers_path ]
      li << [ render_icon_with_text('record', '承租紀錄'), dashboard_rent_records_path ]
      li << [ render_icon_with_text('calendar', '出租日曆'), calendar_dashboard_rent_records_path(role: 'lender') ]
      li << [ render_icon_with_text('calendar', '承租日曆'), calendar_dashboard_rent_records_path(role: 'borrower') ]
    end
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
