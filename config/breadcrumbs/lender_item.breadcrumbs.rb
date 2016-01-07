crumb :lender_items do
  link t('controller.lender/items.action.index'), lender_items_path
end

crumb :account_item_records do |item|
  link t('controller.lender/items.action.records_breadcrumbs', name: render_item_name(item)),
       lender_item_path(item)
  parent :lender_items
end

crumb :new_account_item_record do |item|
  link t('controller.records.action.new'), new_account_item_record_path(item)
  parent :account_item_records, item
end
