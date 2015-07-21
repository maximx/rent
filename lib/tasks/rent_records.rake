namespace :rent_records do
  task :withdraw_overdue => :environment do
    rent_records = RentRecord.booking.where("started_at <= ?", Time.now)
    rent_records.each { |rent_record| rent_record.withdraw! }
  end

  task :notice_return => :environment do
    rent_records = RentRecord.renting.where("ended_at between ? and ?", Time.now, Time.now + 1.hour)

    rent_records.each do |rent_record|
      UserMailer.notify_rent_record_return(rent_record).deliver
    end
  end
end
