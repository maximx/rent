# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# init category
category_list = [ "攝影器材", "服飾", "旅行用品" ]
category_list.each_with_index do |name, serial|
  Category.create(name: name, serial: serial)
end

subcategory_list = [
  [],
  [ "相機", "鏡頭", "燈", "其他週邊" ],
  [ "禮服", "Cosplay", "其他服飾" ],
  [ "行李箱", "嬰兒推車", "行動上網", "其他旅行用品" ]
]
subcategory_list.each_with_index do |sub_list, category_id|
  sub_list.each_with_index do |sub_name, serial|
    subcategory = Subcategory.create(name: sub_name, serial: serial, category_id: category_id)
  end
end

delivers = Deliver.create([
  {name: '宅配/快遞', remit_needed: true, delivery_needed: true},
  {name: '面交自取', address_needed: false},
  {name: '送貨到府(限臺南)'}
])

# init banks
Rake::Task['banks:seeds'].invoke

# init user
user = User.create(
  email: "maxim7667@outlook.com",
  account: "maximx",
  password: "abcdefgh",
  confirmed_at: Time.now
)
user.add_role :company
