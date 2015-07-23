namespace :fake do
  task :users => :environment do
    10.times do
      user = User.new(
        email: FFaker::Internet.email,
        name: FFaker::Name.first_name,
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
        minimum_period: rand(1..3),
        deposit: rand(100..1000),
        address: CityAreaTW.rand_full_cityarea,
        description: FFaker::LoremCN.paragraphs.join(","),
        pictures_attributes: picutres_arr
      )

      item.save
    end
  end

  task :regeocode => :environment do
    while Item.where(latitude: nil).size > 0
      Item.where(latitude: nil).each do |item|
        item.save
      end
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

  task :rent_records => :environment do
    Item.all.each do |item|
      50.times do
        users = User.where.not(id: item.lender)
        user = users[ rand(0..(users.length - 1))]
        started_at = time_rand
        ended_at = time_rand(started_at + 1.day, started_at + rand(3..5).day)

        rent_record = item.rent_records.build(
          user_id: user.id,
          phone: user.profile.phone,
          name: user.profile.name,
          started_at: started_at,
          ended_at: ended_at
        )

        rent_record.save
      end
    end
  end

  def time_rand( from = Time.now, to = Time.local(2015, 10, 30) )
    from = from.to_time if from.is_a? Date
    to = to.to_time if to.is_a? Date
    Time.at(from + rand * (to.to_f - from.to_f)).to_date
  end

end

task fake: [ "fake:users", "fake:profiles", "fake:items", "fake:regeocode", "fake:rent_records" ]
