class OrderLenderLogMailer < ApplicationMailer
  def send_remitted_message(log)
    @bank_account_5 = log.info
    @order = log.order
    @lender_name = log.lender.logo_name
    @borrower_name = log.borrower.logo_name
    mail to: log.lender.email, subject: "[#{t('rent.site_name')}]訂單##{@order.id}承租者#{@borrower_name}匯款通知"
  end
end
