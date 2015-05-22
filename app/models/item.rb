class Item < ActiveRecord::Base
  belongs_to :render, class_name: :User, foreign_key: :user_id
end
