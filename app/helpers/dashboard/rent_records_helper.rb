module Dashboard::RentRecordsHelper
  def render_new_item_rent_record_path item
    link_to render_icon('plus'),
            new_dashboard_item_rent_record_path(item),
            class: 'btn btn-default', title: '新增出租紀錄', data: { toggle: 'tooltip' }
  end

  def render_new_rent_records_breadcrumbs item
    unless dashboard_related_controller?
      breadcrumb :new_rent_record, item
    else
      breadcrumb :new_dashboard_rent_record, item
    end
  end
end
