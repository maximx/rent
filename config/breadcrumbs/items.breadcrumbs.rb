crumb :root do
  link '出租物', items_path
end

crumb :category do |category|
  link category.name, category_path(category)
  parent :root
end

crumb :subcategory do |subcategory|
  link subcategory.name, subcategory_path(subcategory)
  parent :category, subcategory.category
end

crumb :new_item do
  link "新增出租物", new_item_path
  parent :root
end

crumb :item do |item|
  link render_item_name(item), item_path(item)
  parent :subcategory, item.subcategory
end

crumb :item_edit do |item|
  link "修改", edit_item_path(item)
  parent :item, item
end
