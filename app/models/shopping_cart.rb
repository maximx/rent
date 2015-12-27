class ShoppingCart < ActiveRecord::Base
  has_many :shopping_cart_items
  has_many :items, through: :shopping_cart_items

  def add(item)
    unless item_for(item)
      shopping_cart_items.create(item_id: item.id, price: item.price, deliver_fee: item.deliver_fee)
    end
  end

  def remove(item)
    cart_item = item_for(item)
    return unless cart_item
    cart_item.delete
  end

  def item_for(item)
    shopping_cart_items.where(item_id: item.id).first
  end

  def empty?
    shopping_cart_items.empty?
  end

  def clear
    shopping_cart_items.clear
  end
end
