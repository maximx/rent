crumb :new_record do |item|
  link "預約承租", new_item_record_path(item)
  parent :records, item
end

crumb :records do |item|
  link "承租紀錄", item_records_path(item)
  parent :item, item
end

crumb :record do |item, record|
  link record.started_at.to_s(:date_only), item_record_path(item, record)
  parent :records, item
end

crumb :review_record do |item, record|
  link t('controller.reviews.action.new'), new_item_record_review_path(item, record)
  parent :record, item, record
end
