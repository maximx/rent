module Dashboard::RecordsHelper
  def render_new_item_record_path item
    link_to render_icon('plus'),
            new_dashboard_item_record_path(item),
            class: 'btn btn-default', title: '新增出租紀錄', data: { toggle: 'tooltip' }
  end

  def render_new_records_breadcrumbs item
    unless dashboard_related_controller?
      breadcrumb :new_record, item
    else
      breadcrumb :new_dashboard_record, item
    end
  end

  def render_dashboard_records_index_calendar
    render_link_li class: 'nav nav-tabs nav-justified anchor', role: 'tablist' do |li|
      li << [ '承租紀錄列表', dashboard_records_path ]
      li << [ '行事曆', calendar_dashboard_records_path ]
    end
  end
end
