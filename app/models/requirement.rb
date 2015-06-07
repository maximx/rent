class Requirement < ActiveRecord::Base
  validates_presence_of :name, :description

  belongs_to :demander, class_name: "User", foreign_key: "user_id"

  has_many :pictures, as: :imageable
  accepts_nested_attributes_for :pictures
end
