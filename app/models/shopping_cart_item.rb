class ShoppingCartItem < ActiveRecord::Base
  validates_presence_of :deliver_id, on: :update
  validates_presence_of :send_period, if: ->(obj){obj.deliver.present? and obj.deliver.send_home?}, on: :update

  belongs_to :shopping_cart
  belongs_to :item
  belongs_to :deliver

  has_one :lender, through: :item

  # changed with record.item_period, item.period
  enum period: { per_time: 0, per_day: 1 }
  enum send_period: {morning: 0, afternoon: 1, evening: 2}
end
