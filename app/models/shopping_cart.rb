class ShoppingCart < ActiveRecord::Base
  include BookedDates

  attr_accessor :started_at, :ended_at

  validates_presence_of :started_at, :ended_at, unless: :new_record?
  validate :shopping_cart_items_valid?

  has_many :shopping_cart_items
  has_many :items, through: :shopping_cart_items
  has_many :records, through: :items
  accepts_nested_attributes_for :shopping_cart_items

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

  private
    def shopping_cart_items_valid?
      shopping_cart_items.each_with_index do |cart_item, index|
        record_params = {
          started_at: started_at,
          ended_at: ended_at,
          borrower: User.first,
          deliver_id: cart_item.deliver_id
        }
        cart_item.valid?

        record = cart_item.item.records.build(record_params)
        unless record.valid?
          errors.add(:shopping_cart_items,
                     :'record.overlaped',
                     index: (index + 1),
                     msg: record.errors.values.join('，')
          )
        end
      end
    end
end
