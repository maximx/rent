class OrderRecord < ActiveRecord::Base
  belongs_to :order
  belongs_to :record
end
