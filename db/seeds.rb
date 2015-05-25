# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# init user
user = User.new(email: "maxim7667@outlook.com", password: "julius23")
user.save


# init category
category_list = [ "3C物品", "遊戲", "車", "書籍、影片", "服飾裝扮", "空間倉庫", "作業工具", "其他" ]
category_list.each_with_index do |name, serial|
  category = Category.new(name: name, serial: serial)
  category.save
end

subcategory_list = [
  [],
  [ "攝影用具", "電腦及周邊", "其他家電" ],
  [ "遊戲主機", "遊戲光碟", "桌上遊戲" ],
  [ "休旅車", "小客車", "貨車" ],
  [ "戲劇影集", "漫畫", "小說", "其他書籍" ],
  [ "禮服", "首飾配件", "cosplay" ],
  [ "活動場地", "倉庫", "格子" ],
  [ "五金工具", "大型機臺" ],
  [ "運動用具", "旅行物品", "其他" ]
]
subcategory_list.each_with_index do |sub_list, category_id|
  sub_list.each_with_index do |sub_name, serial|
    subcategory = Subcategory.new(name: sub_name, serial: serial, category_id: category_id)
    subcategory.save
  end
end
