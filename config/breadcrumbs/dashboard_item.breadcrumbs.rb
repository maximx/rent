crumb :dashboard_items do
  link '出租物列表', dashboard_items_path
end

crumb :dashboard_rent_records do |item|
  link "#{render_item_name(item)} 的承租紀錄", dashboard_item_rent_records_path(item)
  parent :dashboard_items
end

crumb :new_dashboard_rent_record do |item|
  link '預約承租', new_dashboard_item_rent_record_path(item)
  parent :dashboard_rent_records, item
end
