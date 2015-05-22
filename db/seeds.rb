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
category_name_lists = [ "3C物品", "遊戲", "車", "書籍、影片", "服飾裝扮", "空間倉庫", "作業工具", "運動器具" ]
category_name_lists.each_with_index do |name, index|
  category = Category.new(name: name, serial: index)
  category.save
end
