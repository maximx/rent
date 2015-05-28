class Item < ActiveRecord::Base
  validates_presence_of :name, :price, :period, :category_id, :subcategory_id

  belongs_to :lender, class_name: "User", foreign_key: "user_id"
  belongs_to :category
  belongs_to :subcategory
  has_many :questions, -> { order("created_at DESC") }

  has_many :rent_records, -> { where("ended_at > ?", Time.now).order("started_at") },
    class_name: "RentRecord", foreign_key: "item_id"
  has_many :borrowers, through: :rent_records, source: :user

  has_many :collect_relationships, class_name: "ItemCollection", foreign_key: "item_id"
  has_many :collector, through: :collect_relationships, source: :user

  enum period: [ :時, :日, :月, :年 ]

  geocoded_by :address
  after_validation :geocode

  before_validation :set_category_id

  def editable_by?(user)
    user && user == lender
  end

  def self.search_by(query)
    where(search_criteria(query))
  end

  protected

  def set_category_id
    self.category_id = Subcategory.find(subcategory_id).category_id
  end

  def self.search_criteria(query)
    search_arr(query).push( keywords(query) ).flatten
  end

  def self.keywords(query)
    query.split.collect { |keyword| "%#{keyword}%" }
  end

  def self.search_arr(query)
    [ Array.new( keywords(query).size, basic_search_str ).join(" and ") ]
  end

  def self.basic_search_str
    "concat(name, description) like ?"
  end
end
