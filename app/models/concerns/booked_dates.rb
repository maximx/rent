module BookedDates
  def booked_dates
    dates = records.actived
                   .where('ended_at > ?', Time.now)
                   .collect { |record| (record.started_at.to_date .. (record.ended_at).to_date).map(&:to_s) }
    dates << Time.now.yesterday.to_date.to_s
    dates.flatten
  end
end
