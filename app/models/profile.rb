class Profile < ActiveRecord::Base
  belongs_to :user
  has_one :picture, as: :imageable, dependent: :destroy
  validates_length_of :bank_code, minimum: 3, maximum:3 , allow_blank: true
  validates_presence_of :bank_account, if: :bank_code?
  accepts_nested_attributes_for :picture
end
