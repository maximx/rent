class RecordStateLogMailer < ApplicationMailer
  def send_remitted_message(log)
    @account_5 = log.info
    @record = log.record
    @item = @record.item
    lender = @record.lender
    @lender_name = lender.profile.logo_name
    @borrower_name = @record.borrower.profile.logo_name
    mail to: lender.email, subject: "[廣和租賃行]物品#{@item.name}承租者#{@borrower_name}匯款通知"
  end
end
