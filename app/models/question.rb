class Question < ActiveRecord::Base
  validates_presence_of :content

  belongs_to :item
  belongs_to :asker, class_name: "User", foreign_key: "user_id"

  after_create :send_new_question_message

  def replied_by?(user)
    user && user == self.item.lender
  end

  def send_new_question_message
    UserMailer.notify_question(self.item.lender, self).deliver
  end
end
