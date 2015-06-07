class Requirement < ActiveRecord::Base
  validates_presence_of :name, :content

  belongs_to :demander, class_name: "User", foreign_key: "user_id"
  has_many :pictures, as: :imageable
end
