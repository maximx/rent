class OrderMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.send_payment_message.subject
  #
  def send_payment_message(order, profile, records)
    @order = order
    @profile = profile
    @count = records.count

    @sum = 0
    records.map{|record| @sum += record.total_price if record.may_remit?}

    if @sum > 0
      mail to: order.borrower.email,
           subject: t('order_mailer.send_payment_message.subject', order_id: order.id, name: profile.logo_name)
    end
  end
end
