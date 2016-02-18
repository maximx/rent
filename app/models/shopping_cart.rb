class ShoppingCart < ActiveRecord::Base
  include BookedDates

  attr_accessor :started_at, :ended_at

  validates_presence_of :started_at, :ended_at, unless: :new_record?
  validate :shopping_cart_items_valid?

  belongs_to :user, polymorphic: true

  has_many :shopping_cart_items
  accepts_nested_attributes_for :shopping_cart_items

  has_many :items, through: :shopping_cart_items
  has_many :records, through: :items
  has_many :lenders, ->{uniq}, through: :items

  def add(item)
    unless item_for(item)
      shopping_cart_items.create(
        item_id: item.id,
        price: item.price,
        deliver_fee: item.deliver_fee,
        free_days: item.lender.free_days,
        deposit: item.deposit,
        period: item.period
      )
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
    shopping_cart_items.delete_all
  end

  def shopping_cart_lender_items
    shopping_cart_items.group_by(&:lender)
  end

  def checkout
    order_price, order_deposit, order_deliver_fee = 0, 0, 0

    order = user.orders.create(started_at: started_at, ended_at: ended_at)

    shopping_cart_lender_items.each do |lender, shopping_cart_items|
      lender_price, lender_deposit, lender_deliver_fee = 0, 0, 0

      order_lender = order.order_lenders.create!(
        lender: lender,
        deliver: shopping_cart_items.first.deliver
      )

      shopping_cart_items.each do |shopping_cart_item|
        record_params = shopping_cart_item_record_params(shopping_cart_item)
        record = shopping_cart_item.item.records.build(record_params)
        record.attributes = { order: order, order_lender: order_lender }
        record.save

        # 業者此份訂單總金額計算
        lender_price       += record.price
        lender_deposit     += record.item_deposit
        lender_deliver_fee += record.deliver_fee if record.delivery_needed?
      end

      # 紀錄業者訂單金額
      order_lender.update(
        price:       lender_price,
        deposit:     lender_deposit,
        deliver_fee: lender_deliver_fee
      )

      # 訂單總金額計算
      order_price       += lender_price
      order_deposit     += lender_deposit
      order_deliver_fee += lender_deliver_fee
    end
    clear

    # 紀錄訂單總金額
    order.update(
      price:       order_price,
      deposit:     order_deposit,
      deliver_fee: order_deliver_fee
    )
    order
  end

  def lender_request_borrower_info_needed?
    lenders.each {|lender| return true if lender.borrower_info_provide}
    return false
  end

  private
    def shopping_cart_items_valid?
      shopping_cart_items.each_with_index do |shopping_cart_item, index|
        shopping_cart_item.valid?
        record_params = shopping_cart_item_record_params(shopping_cart_item)
        record = shopping_cart_item.item.records.build(record_params)

        unless record.valid?
          errors.add(:shopping_cart_items,
                     :'record.overlaped',
                     index: (index + 1),
                     msg: record.errors.values.join('，')
          )
        end
      end
    end

    def shopping_cart_item_record_params(shopping_cart_item)
      {
        started_at: started_at,
        ended_at: ended_at,
        borrower: user,
        item_price: shopping_cart_item.price,
        deliver_id: shopping_cart_item.deliver_id,
        deliver_fee: shopping_cart_item.deliver_fee,
        item_deposit: shopping_cart_item.deposit,
        free_days: shopping_cart_item.free_days,
        item_period: shopping_cart_item.period,
        send_period: shopping_cart_item.send_period
      }
    end
end
