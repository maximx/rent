# Preview all emails at http://localhost:3000/rails/mailers/rent_record_mailer
class RentRecordMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/rent_record_mailer/notify_remit_info
  def notify_remit_info
    RentRecordMailer.notify_remit_info
  end

end
