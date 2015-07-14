crumb :root do
  link "首頁", root_path
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
  link item.name, item_path(item)
  parent :subcategory, item.subcategory
end

crumb :item_edit do |item|
  link "修改", edit_item_path(item)
  parent :item, item
end

crumb :item_calendar do |item|
  link "出租日曆", calendar_item_path(item)
  parent :item, item
end

crumb :item_questions do |item|
  link "問與答", questions_item_path(item)
  parent :item, item
end
