class ShoppingCartItem < ActiveRecord::Base
  include CurrencyPrice

  belongs_to :shopping_cart
  belongs_to :item
  belongs_to :deliver

  validates_presence_of :deliver_id, on: :update
end
