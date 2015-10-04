class QuestionMailer < ApplicationMailer
  add_template_helper PicturesHelper

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.question_mailer.notify_question.subject
  #
  def notify_question_reply(question)
    @question = question
    @item = @question.item
    mail to: question.asker.email, subject: "#{@item.lender.email}已回覆您對出租物#{@item.name}所提出的疑問"
  end
end
