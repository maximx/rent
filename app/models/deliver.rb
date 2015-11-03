class Deliver < ActiveRecord::Base
  has_many :item_deliver, dependent: :destroy
  has_many :items, through: :item_deliver

  def self.face_to_face
    where(name: '面交自取').first
  end
end
