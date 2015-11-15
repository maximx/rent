module Dashboard::RentRecordsHelper
  def render_new_item_rent_record_path item
    link_to render_icon('plus'),
            new_dashboard_item_rent_record_path(item),
            class: 'btn btn-default', title: '新增出租紀錄', data: { toggle: 'tooltip' }
  end
end
