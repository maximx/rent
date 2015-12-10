class ItemsSelection < ActiveRecord::Base
  belongs_to :item
  belongs_to :selection
end
