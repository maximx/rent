class OrderLender < ActiveRecord::Base
  validates_presence_of :order_id, :lender_id, :deliver_id
  validates :deliver_id, inclusion: { in: ->(obj){ obj.lender.delivers.pluck(:id) } }

  belongs_to :order
  belongs_to :lender, class_name: 'User'
  belongs_to :deliver
end
