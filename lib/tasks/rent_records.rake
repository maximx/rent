namespace :rent_records do
  task :withdraw_overdue => :environment do
    rent_records = RentRecord.booking.where("started_at <= ?", Time.now)
    rent_records.each { |rent_record| rent_record.withdraw! }
  end
end
