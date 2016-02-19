class OrderLenderMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.send_payment_message.subject
  #
  def send_payment_message(order_lender)
    if order_lender.remit_needed?
      @order = order_lender.order
      @lender_profile = order_lender.lender.profile
      @count = order_lender.records.count
      @total_price = order_lender.total_price

      mail to: @order.borrower.email,
           subject: t('order_mailer.send_payment_message.subject',
                      order_id: order_lender.order_id,
                      name: @lender_profile.logo_name)
    end
  end
end
