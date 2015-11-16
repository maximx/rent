namespace :fake do
  task :users => :environment do
    15.times do
      user = User.new(
        email: FFaker::Internet.email,
        account: FFaker::Name.first_name,
        password: "abcdefgh",
        confirmed_at: Time.now
      )

      user.save
    end
  end

  task :items => :environment do
    require 'city_area_tw'

    users = User.all
    cities = City.all
    subcategories = Subcategory.all
    deliver_1 = Deliver.find 1
    deliver_2 = Deliver.find 2

    100.times do
      picutres_arr = []
      rand(1..4).times do
        picutres_arr << { public_id: "test#{rand(1..7)}", file_cached: 'faker' }
      end

      deliver_arr = []
      deliver_arr << deliver_1.id if rand(0..1) == 1
      deliver_arr << deliver_2.id if rand(0..1) == 1 || deliver_arr.empty?

      city = cities.sample

      item = users.sample.items.build(
        name: FFaker::LoremCN.words.join(" "),
        subcategory_id: subcategories.sample.id,
        price: rand(0..20),
        minimum_period: rand(1..3),
        deposit: rand(0..1000),
        address: city.name + CityAreaTW.rand_area_at(city),
        description: FFaker::LoremCN.paragraphs.join(","),
        deliver_ids: deliver_arr,
        pictures_attributes: picutres_arr
      )

      if deliver_arr.include?(1)
        profile = item.lender.profile

        profile.name = FFaker::NameCN.name
        profile.address = FFaker::AddressAU.full_address,
        profile.bank_code = '700'
        profile.bank_account = '123456789000'

        profile.save
      end

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
      15.times do
        users = User.where.not(id: item.lender)
        started_at = time_rand
        ended_at = time_rand(started_at + 1.day, started_at + rand(3..5).day)

        rent_record = item.rent_records.build(
          deliver_id: item.delivers.sample.id,
          started_at: started_at,
          ended_at: ended_at
        )
        rent_record.borrower = users.sample

        rent_record.save
      end
    end
  end

  def time_rand( from = Time.now, to = Time.local(2015, 12, 30) )
    from = from.to_time if from.is_a? Date
    to = to.to_time if to.is_a? Date
    Time.at(from + rand * (to.to_f - from.to_f)).to_date
  end
end

task fake: [ "fake:users", "fake:profiles", "fake:items", "fake:regeocode", "fake:rent_records" ]
