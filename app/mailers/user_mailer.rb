class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.notify_question.subject
  #
  def notify_question(user, question)
    @user = user
    @question = question
    @item = @question.item
    @asker = @question.asker

    mail to: user.email, subject: "出租物#{@item.name}有人提出新問題，請您回覆"
  end
end
