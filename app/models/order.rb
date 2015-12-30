class Order < ActiveRecord::Base
  include CurrencyPrice

  belongs_to :user, polymorphic: true
  has_many :records
end
