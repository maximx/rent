class ItemDeliver < ActiveRecord::Base
  validates_presence_of :item_id, :deliver_id

  belongs_to :item
  belongs_to :deliver
end
