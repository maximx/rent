class ShoppingCartItem < ActiveRecord::Base
  belongs_to :shopping_cart
  belongs_to :item
end
