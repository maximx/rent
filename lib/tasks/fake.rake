namespace :fake do
  task :users => :environment do
    10.times do
      user = User.new(
        email: FFaker::Internet.email,
        password: "julius23",
        confirmed_at: Time.now
      )

      user.save
    end
  end

  task :items => :environment do
    require 'city_area_tw'

    user_count = User.count
    subcategory_count = Subcategory.count

    100.times do
      picutres_arr = []
      rand(1..4).times do
        picutres_arr << {public_id: "test#{rand(1..7)}"}
      end

      user = User.find( rand(1..user_count) )

      item = user.items.build(
        name: FFaker::LoremCN.words.join(" "),
        subcategory_id: rand(1..subcategory_count),
        price: rand(1..20),
        minimum_period: rand(1..7),
        deposit: rand(100..1000),
        address: CityAreaTW.rand_full_cityarea,
        description: FFaker::LoremCN.paragraphs.join(","),
        pictures_attributes: picutres_arr
      )

      item.save
    end
  end

  task :regeocode => :environment do
    items = Item.where(latitude: nil)
    items.each do |item|
      item.save
    end
  end

  task :profiles => :environment do
    User.all.each do |u|
      profile = u.build_profile(
        name: FFaker::NameCN.name,
        phone: FFaker::PhoneNumberCU.home_work_phone_number,
        address: FFaker::AddressAU.full_address,
        description: FFaker::LoremCN.paragraphs.join(","),
        picture_attributes: { public_id: "test-avatar#{rand(1..4)}" }
      )

      profile.save
    end
  end

end

task fake: [ "fake:users", "fake:profiles", "fake:items", "fake:regeocode" ]
