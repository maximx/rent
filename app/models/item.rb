class Item < ActiveRecord::Base
  validates_presence_of :name, :price, :period, :category_id, :subcategory_id

  belongs_to :render, class_name: "User", foreign_key: "user_id"
  has_one :category
  has_one :subcategory
  has_many :questions

  enum period: [ :時, :日, :月, :年 ]

  def editable_by?(user)
    user && user == render
  end
end
