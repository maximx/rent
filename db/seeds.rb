# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# init user
user = User.new(
  email: "maxim7667@outlook.com",
  account: "maximx",
  password: "abcdefgh",
  confirmed_at: Time.now
)
user.save


# init category
# 車可能會有麻煩，先移除
#category_list = [ "3C物品", "遊戲", "書籍、影片", "服飾裝扮", "空間倉庫", "作業工具", "其他", "車" ]
category_list = [ "3C物品", "遊戲", "書籍、影片", "服飾裝扮", "作業工具", "其他" ]
category_list.each_with_index do |name, serial|
  category = Category.new(name: name, serial: serial)
  category.save
end

subcategory_list = [
  [],
  [ "攝影用具", "電腦及周邊", "其他家電" ],
  [ "遊戲主機", "遊戲光碟", "桌上遊戲" ],
  [ "戲劇影集", "漫畫", "小說", "其他書籍" ],
  [ "禮服", "首飾配件", "Cosplay" ],
  #[ "活動場地", "倉庫", "格子" ],
  [ "五金工具", "大型機臺" ],
  [ "運動用具", "旅行物品", "其他" ]
  #[ "休旅車", "小客車", "貨車" ]
]
subcategory_list.each_with_index do |sub_list, category_id|
  sub_list.each_with_index do |sub_name, serial|
    subcategory = Subcategory.new(name: sub_name, serial: serial, category_id: category_id)
    subcategory.save
  end
end


# init city
city_list = %w(基隆市 臺北市 新北市 桃園市 新竹市 新竹縣 苗栗縣 臺中市 彰化縣 南投縣 雲林縣 嘉義市 嘉義縣 臺南市 高雄市 屏東縣 臺東縣 花蓮縣 宜蘭縣 澎湖縣 金門縣 連江縣)
city_list.each do |city_name|
  city = City.new(name: city_name)
  city.save
end

deliver_list = %w(郵局寄送 面交自取)
deliver_list.each do |deliver_name|
  deliver = Deliver.new(name: deliver_name)
  deliver.save
end

# init banks
Rake::Task['banks:seeds'].invoke
