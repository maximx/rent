class Item < ActiveRecord::Base
  include CurrencyPrice

  PRICE_MIN = 5
  PRICE_MAX = 500

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

  enum period: [ :每日, :每月, :每年 ]

  geocoded_by :address
  after_validation :geocode

  self.per_page = 20

  before_save :set_category_and_price

  scope :search_by, -> (query) { where(search_criteria(query)) if query.present? }
  scope :city_at, -> (query) { where('items.address regexp ?', tai_word(query)) if query.present? }

  scope :price_range, -> (min, max) { price_greater_than(min).price_less_than(max) }
  scope :price_greater_than, -> (min) { where('price >= ?', min) if min.present? && min != PRICE_MIN }
  scope :price_less_than, -> (max) { where('price <= ?', max) if max.present? && max != PRICE_MAX }

  scope :record_overlaps, ->(started_at, ended_at) do
    where(id: RentRecord.select(:id, :item_id).overlaps(started_at, ended_at).pluck(:item_id))
  end
  scope :record_not_overlaps, ->(started_at, ended_at) do
    where.not(id: record_overlaps(started_at, ended_at))
  end

  scope :index_pictures_urls, -> { all.map{ |i| cloudinary_url(i.index_picture_public_id) }.uniq }

  def editable_by?(user)
    user && user == lender
  end

  def rentable_by?(user)
    user && user != lender
  end

  def city
    address[0..2]
  end

  def period_without_per
    period.slice(1)
  end

  def price_period
    "#{currency_price}/#{period}"
  end

  def self.overlaps_types
    [["尚未出租", "record_not_overlaps"], ["已出租", "record_overlaps"]]
  end

  def self.overlaps_values
    self.overlaps_types.to_h.values
  end

  def meta_keywords
    Rent::KEYWORDS + category.name.split("、") + [subcategory.name] + name.split(" ").join("、").split("、")
  end

  def meta_description
    "租金∶#{price_period}。#{ApplicationController.helpers.strip_tags(description)}"
  end

  def index_picture_public_id
    pictures.first.public_id
  end

  def pictures_urls
    pictures.map { |p| self.class.cloudinary_url(p.public_id) }.uniq
  end

  def reviews
    Review.where(rent_record_id: rent_records)
  end

  def booked_dates
    rent_records.booking.where('started_at > ?', Time.now)
      .collect { |rent_record| (rent_record.started_at.to_date .. rent_record.ended_at.to_date).map(&:to_s) }
      .flatten
  end

  protected

  def set_category_and_price
    self.price ||= 0
    self.deposit ||= 0
    self.down_payment ||= 0
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
    "concat(items.name, items.description) like ?"
  end

  def self.tai_word(str)
    arr = [str]
    arr << str.sub("臺", "台")
    arr.uniq.join("|")
  end

  def self.cloudinary_url(public_id)
    Cloudinary::Utils.cloudinary_url(public_id)
  end
end
