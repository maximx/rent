class Item < ActiveRecord::Base
  include CurrencyPrice

  validates_presence_of :name, :price, :minimum_period, :subcategory_id, :pictures

  belongs_to :lender, class_name: "User", foreign_key: "user_id"
  belongs_to :category
  belongs_to :subcategory
  has_many :questions, -> { order("created_at").reverse_order }, dependent: :destroy

  has_many :rent_records, -> { order(started_at: :desc) }, class_name: "RentRecord", foreign_key: "item_id"
  has_many :borrowers, through: :rent_records, source: :user

  has_many :collect_relationships, class_name: "ItemCollection", foreign_key: "item_id", dependent: :destroy
  has_many :collector, through: :collect_relationships, source: :user

  has_many :pictures, as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :pictures

  enum period: [ :時, :日, :月, :年 ]

  geocoded_by :address
  after_validation :geocode

  before_save :set_category_id

  scope :search_by, -> (query) { where(search_criteria(query)) }

  scope :record_overlaps, ->(started_at, ended_at) do
    where(id: RentRecord.select(:id, :item_id).overlaps(started_at, ended_at).pluck(:item_id))
  end
  scope :record_not_overlaps, ->(started_at, ended_at) do
    where.not(id: record_overlaps(started_at, ended_at))
  end

  def editable_by?(user)
    user && user == lender
  end

  def city
    address[0..2]
  end

  def price_period
    "$#{price}/#{period}"
  end

  def active_records
    rent_records.where.not(aasm_state: "withdrawed").order(started_at: :desc)
  end

  def self.overlaps_types
    [["尚未出租", "record_not_overlaps"], ["已出租", "record_overlaps"]]
  end

  protected

  def set_category_id
    self.category_id = Subcategory.find(subcategory_id).category_id
  end

  def self.search_criteria(query)
    search_arr(query).push( keywords(query) ).flatten if query
  end

  def self.keywords(query)
    query.split.collect { |keyword| "%#{keyword}%" }
  end

  def self.search_arr(query)
    [ Array.new( keywords(query).size, basic_search_str ).join(" and ") ]
  end

  def self.basic_search_str
    "concat(items.name, items.description) like ?"
  end
end
