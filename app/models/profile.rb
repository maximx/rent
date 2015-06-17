class Profile < ActiveRecord::Base
  validates_presence_of :name, :picture

  belongs_to :user
  has_one :picture, as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :picture
end
