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

  def ask_for_review(judger, review, user)
    @judger = judger
    @review = review
    @user = user
    @item = review.rent_record.item

    mail to: user.email, subject: ask_for_review_subject
  end

  private
    def ask_for_review_subject
      "#{@judger.email}對#{@item.name}的承租交易評價為#{@review.rate}，並請您對他評價"
    end

end
