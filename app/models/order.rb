class Order < ActiveRecord::Base
  include CurrencyPrice

  belongs_to :borrower, polymorphic: true
  has_many :records
end
