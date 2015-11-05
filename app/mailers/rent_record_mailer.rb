class RentRecordMailer < ApplicationMailer
  add_template_helper RentRecordsHelper

  def notify_rent_record_return(rent_record)
    @borrower_name = rent_record.borrower.profile.name
    @rent_record = rent_record
    @lender = rent_record.item.lender

    mail to: rent_record.borrower.email, subject: "承租物#{rent_record.item.name}即將到期"
  end

  def send_payment_message(rent_record)
    @borrower_name = rent_record.borrower.profile.name
    @rent_record = rent_record
    @lender = rent_record.item.lender

    mail to: rent_record.borrower.email, subject: "#{Rent::SITE_NAME}-承租物#{rent_record.item.name}匯款通知"
  end
end
