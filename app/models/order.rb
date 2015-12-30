class Order < ActiveRecord::Base
  include CurrencyPrice

  belongs_to :borrower, polymorphic: true
  has_many :records

  scope :recent, -> { order(:created_at).reverse_order }
end
