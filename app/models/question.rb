class Question < ActiveRecord::Base
  validates_presence_of :content

  belongs_to :item
  belongs_to :asker, class_name: "User", foreign_key: "user_id"

  after_create :send_new_question_message
  after_update :send_reply_question_message

  def replied_by?(user)
    user && user == self.item.lender
  end

  def send_new_question_message
    QuestionMailer.notify_question(self).deliver
  end

  def send_reply_question_message
    QuestionMailer.notify_question_reply(self).deliver
  end
end
