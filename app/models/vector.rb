class Vector < ActiveRecord::Base
  belongs_to :user
  belongs_to :subcategory
  belongs_to :tag
end
