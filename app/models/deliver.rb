class Deliver < ActiveRecord::Base
  has_many :item_deliver, dependent: :destroy
  has_many :items, through: :item_deliver

  def remit_needed?
    remit_needed
  end

  def delivery_needed?
    delivery_needed
  end

  def address_needed?
    address_needed
  end
end
