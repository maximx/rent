class Picture < ActiveRecord::Base
  validates_presence_of :public_id
  belongs_to :imageable, polymorphic: true
end
