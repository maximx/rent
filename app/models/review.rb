class Review < ActiveRecord::Base
  validates_presence_of :content, :rate

  belongs_to :judger, class_name: "User", foreign_key: "judger_id"
  belongs_to :user
  belongs_to :rent_record

  enum rate: [ :bad, :good ]
  enum user_role: [ :lender, :borrower ]
end
