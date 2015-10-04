crumb :new_rent_record do |item|
  link "預約承租", new_item_rent_record_path(item)
  parent :item, item
end

crumb :rent_records do |item|
  link "承租紀錄", item_rent_records_path(item)
  parent :item, item
end

crumb :rent_record do |item, rent_record|
  link rent_record.started_at.to_s(:date_only), item_rent_record_path(item, rent_record)
  parent :rent_records, item
end

crumb :review_rent_record do |item, rent_record|
  link "評價", review_item_rent_record_path(item, rent_record)
  parent :rent_record, item, rent_record
end
