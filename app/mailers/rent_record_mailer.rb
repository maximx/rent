class RentRecordMailer < ApplicationMailer
  add_template_helper RentRecordsHelper

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.rent_record_mailer.notify_remit_info.subject
  #
  def notify_remit_info(rent_record)
    @rent_record = rent_record
    @item = @rent_record.item

    lender = rent_record.lender
    @bank_code = lender.profile.bank_code
    @bank_account = lender.profile.bank_account

    mail to: @rent_record.borrower.email, subject: "您已預約承租#{@item.name},請於24小時內完成匯款"
  end
end
