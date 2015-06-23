crumb :new_rent_record do |item|
  link "預約承租", new_item_rent_record_path(item)
  parent :item, item
end

crumb :rent_records do |item|
  link "承租紀錄", item_rent_records_path(item)
  parent :item, item
end

crumb :rent_record do |item, rent_record|
  link render_date(rent_record.started_at), item_rent_record_path(item, rent_record)
  parent :rent_records, item
end

crumb :edit_rent_record do |item, rent_record|
  link "修改", edit_item_rent_record_path(item, rent_record)
  parent :rent_record, item, rent_record
end
