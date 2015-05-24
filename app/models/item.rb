class Item < ActiveRecord::Base
  validates_presence_of :name, :price, :period, :category_id, :subcategory_id

  belongs_to :lender, class_name: "User", foreign_key: "user_id"
  has_one :category
  has_one :subcategory
  has_many :questions, -> { order("created_at DESC") }

  has_many :rent_records, -> { where("ended_at > ?", Time.now).order("started_at") },
    class_name: "RentRecord", foreign_key: "item_id"
  has_many :borrowers, through: :rent_records, source: :user

  enum period: [ :時, :日, :月, :年 ]

  geocoded_by :address
  after_validation :geocode

  def editable_by?(user)
    user && user == lender
  end
end
