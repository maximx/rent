class Item < ActiveRecord::Base
  include AASM
  include CurrencyPrice

  self.per_page = 20
  PRICE_MIN = 0
  PRICE_MAX = 500

  validates_presence_of :name, :price, :minimum_period, :subcategory_id, :deliver_ids, :aasm_state
  validates_presence_of :address, if: :delivers_include_face?
  validates_numericality_of :deliver_fee, equal_to: 0, unless: :delivers_include_non_face?
  validate :profile_bank_info_presented, if: :delivers_include_non_face?

  belongs_to :lender, class_name: "User", foreign_key: "user_id"
  belongs_to :category
  belongs_to :subcategory
  has_many :questions, -> { order("created_at").reverse_order }, dependent: :destroy
  belongs_to :city

  has_many :records, -> { order(started_at: :desc) }, class_name: 'Record', foreign_key: 'item_id'
  has_many :borrowers, through: :records, source: :user

  has_many :collect_relationships, class_name: "ItemCollection", foreign_key: "item_id", dependent: :destroy
  has_many :collectors, through: :collect_relationships, source: :user

  has_many :pictures, class_name: 'Attachment', as: :attachable, dependent: :destroy

  has_many :item_deliver, dependent: :destroy
  has_many :delivers, through: :item_deliver

  enum period: [ :每日, :每月, :每年 ]

  geocoded_by :address, if: ->(obj){ obj.address.present? and obj.address_changed? }

  after_initialize :init_address
  after_validation :geocode
  before_save :set_category_and_price, :set_city

  scope :search_by, -> (query) { where(search_criteria(query)) if query.present? }
  scope :city_at, -> (city_id) { where(city_id: city_id) if city_id.present? }

  scope :price_range, -> (min, max) { price_greater_than(min).price_less_than(max) }
  scope :price_greater_than, -> (min) { where('price >= ?', min) if min.present? && min != PRICE_MIN }
  scope :price_less_than, -> (max) { where('price <= ?', max) if max.present? && max != PRICE_MAX }

  scope :record_overlaps, ->(started_at, ended_at) do
    where(id: Record.select(:id, :item_id).overlaps(started_at, ended_at).pluck(:item_id))
  end
  scope :record_not_overlaps, ->(started_at, ended_at) do
    where.not(id: record_overlaps(started_at, ended_at))
  end

  scope :index_pictures_urls, -> { all.map{ |i| cloudinary_url(i.index_picture_public_id) }.uniq }

  aasm no_direct_assignment: true do
    state :opening, initial: true
    state :closed

    event :close do
      transitions from: :opening, to: :closed
    end

    event :open do
      transitions from: :closed, to: :opening
    end
  end

  def init_address
    self.address = lender.profile.address
  end

  def profile_bank_info_presented
    unless lender.profile.bank_info_present?
      errors.add(:delivers, '請先填寫匯款資訊')
    end
  end

  def editable_by?(user)
    user && user == lender
  end

  def rentable_by?(user)
    user and user != lender and opening?
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
    I18n.t('rent.keywords') + category.name.split("、") + [subcategory.name] + name.split(" ").join("、").split("、")
  end

  def meta_description
    "租金∶#{price_period}。#{ApplicationController.helpers.strip_tags(description)}"
  end

  def cover_picture
    pictures.first
  end

  def pictures_urls
    pictures.map { |p| p.image.url }.uniq
  end

  def reviews
    Review.where(record_id: records)
  end

  def booked_dates
    dates = records.actived
                   .where('ended_at > ?', Time.now)
                   .collect { |record| (record.started_at.to_date .. (record.ended_at).to_date).map(&:to_s) }
    dates << Time.now.yesterday.to_date.to_s
    dates.flatten
  end

  def delivers_include_face?
    delivers.include?( Deliver.face_to_face )
  end

  def delivers_include_non_face?
    delivers.include?( Deliver.where.not(name: '面交自取').first )
  end

  def collected_by? user
    collectors.include? user
  end

  protected

  def set_category_and_price
    self.price ||= 0
    self.deposit ||= 0
    self.category_id = Subcategory.find(subcategory_id).category_id
  end

  def set_city
    if geo_address = Geocoder.address([latitude, longitude], language: 'zh-TW')
      city_name, level = geo_address.match(/(\D{2}(市|縣))/i).captures
    elsif m = address.match(/(\D{2}(市|縣))/i)
      city_name, level = m.captures
    end

    if city_name
      cities = City.where(name: city_name.sub('台', '臺'))
      self.city = cities.first
    end
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

  def self.cloudinary_url(public_id)
    Cloudinary::Utils.cloudinary_url(public_id)
  end
end
