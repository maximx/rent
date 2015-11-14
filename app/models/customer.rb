class Customer < ActiveRecord::Base
  belongs_to :user
  has_many :rent_records, as: :borrower

  has_one :profile
  accepts_nested_attributes_for :profile

  def account
    profile.name
  end
end
