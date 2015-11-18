namespace :records do
  task :withdraw_overdue => :environment do
    records = Record.booking.where("started_at <= ?", Time.now - 1.hour)
    records.each { |record| record.withdraw! }
  end

  task :notice_return => :environment do
    records = Record.renting.where("ended_at between ? and ?", Time.now, Time.now + 1.hour)

    records.each do |record|
      RecordMailer.notify_record_return(record).deliver
    end
  end
end
