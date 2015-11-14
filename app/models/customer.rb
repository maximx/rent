class Customer < ActiveRecord::Base
  has_one :profile
  has_many :rent_records, as: :borrower
end
