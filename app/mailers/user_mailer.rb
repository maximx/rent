class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.notify_question.subject
  #
  def notify_question(lender, question)
    @lender = lender
    @question = question
    @item = @question.item
    @asker = @question.asker

    mail to: lender.email, subject: "出租物#{@item.name}有人提出新問題，請您回覆"
  end

  def notify_question_reply(asker, question)
    @asker = asker
    @question = question
    @item = @question.item
    @lender = @item.lender

    mail to: asker.email, subject: "#{@lender.email}已回覆您對出租物#{@item.name}所提出的疑問"
  end
end
