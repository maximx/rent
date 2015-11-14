class Customer < ActiveRecord::Base
  belongs_to :user
  has_one :profile
  has_many :rent_records, as: :borrower

  def account
    profile.name
  end
end
