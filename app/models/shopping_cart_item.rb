class ShoppingCartItem < ActiveRecord::Base
  include CurrencyPrice

  validates_presence_of :deliver_id, on: :update

  belongs_to :shopping_cart
  belongs_to :item
  belongs_to :deliver

  has_one :lender, through: :item

  # changed with record.item_period, item.period
  enum period: { per_time: 0, per_day: 1 }

  def price_period
    "#{currency_price}/#{period_i18n}"
  end
end
