class Question < ActiveRecord::Base
  validates_presence_of :content

  belongs_to :item
  belongs_to :asker, class_name: "User", foreign_key: "user_id"

  def replied_by?(user)
    user && user == self.item.lender
  end
end
