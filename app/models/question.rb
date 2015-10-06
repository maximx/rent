class Question < ActiveRecord::Base
  validates_presence_of :content

  belongs_to :item
  belongs_to :asker, class_name: "User", foreign_key: "user_id"

  def replied_by?(user)
    user && user == self.item.lender
  end

  def notify_new_question_subject
    "請回覆#{asker.account}的問題 - #{item.name}"
  end

  def notify_reply_question_subject
    "#{item.lender.account}已回覆您的問題 - #{item.name}"
  end
end
