crumb :account_items do
  link t('controller.account/items.action.index'), account_items_path
end

crumb :account_item_records do |item|
  link t('controller.account/items.action.records_breadcrumbs', name: render_item_name(item)),
       account_item_records_path(item)
  parent :account_items
end

crumb :new_account_item_record do |item|
  link t('controller.records.action.new'), new_account_item_record_path(item)
  parent :account_item_records, item
end
