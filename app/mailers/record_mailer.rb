class RecordMailer < ApplicationMailer
  add_template_helper RecordsHelper

  def notify_record_return(record)
    @borrower_name = record.borrower.profile.name
    @record = record
    @lender = record.item.lender

    mail to: record.borrower.email, subject: "承租物#{record.item.name}即將到期"
  end
end
