class Deliver < ActiveRecord::Base
  has_many :item_deliver, dependent: :destroy
  has_many :items, through: :item_deliver
end
