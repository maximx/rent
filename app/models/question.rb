class Question < ActiveRecord::Base
  belongs_to :item
  belongs_to :asker, class_name: "User", foreign_key: "user_id"
end
