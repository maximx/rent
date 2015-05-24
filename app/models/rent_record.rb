class RentRecord < ActiveRecord::Base
  belongs_to :borrower, class_name: "User", foreign_key: "user_id"
  belongs_to :item
end
