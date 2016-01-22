namespace :once do
  task :build_user_deliver => :environment do
    users = User.all
    delivers = Deliver.where(id: [1, 2])
    users.each do |user|
      user.delivers << delivers if user.delivers.empty?
    end
  end

  task :add_send_home_deliver => :environment do
    Deliver.create(name: '送貨到府(限臺南)')
    deliver = Deliver.find 1
    deliver.update remit_needed: true, delivery_needed: true
    deliver = Deliver.find 2
    deliver.update address_needed: false
  end
end
