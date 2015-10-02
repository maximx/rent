class RentRecordMailer < ApplicationMailer
  add_template_helper RentRecordsHelper

  def notify_remit_info(rent_record)
    @rent_record = rent_record
    @item = @rent_record.item

    lender = rent_record.lender
    @bank_code = lender.profile.bank_code
    @bank_account = lender.profile.bank_account

    mail to: @rent_record.borrower.email, subject: "您已預約承租#{@item.name},請於24小時內完成匯款"
  end

  def ask_for_review(judger, review, user)
    @judger = judger
    @review = review
    @user = user
    @item = review.item

    mail to: user.email, subject: ask_for_review_subject
  end

  def notify_rent_record_return(rent_record)
    @borrower_name = rent_record.borrower.profile.name
    @rent_record = rent_record
    @lender = rent_record.item.lender

    mail to: rent_record.borrower.email, subject: "承租物#{rent_record.item.name}即將到期"
  end

  private
    def ask_for_review_subject
      "#{@judger.email}對#{@item.name}的承租交易評價為#{@review.rate}，並請您對他評價"
    end
end
