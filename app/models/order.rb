class Order < ActiveRecord::Base
  belongs_to :user, polymorphic: true
  has_many :order_records
  has_many :records, through: :order_records
end
