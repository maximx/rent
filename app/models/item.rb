class Item < ActiveRecord::Base
  include AASM
  include CurrencyPrice

  self.per_page = 20
  PRICE_MIN = 0
  PRICE_MAX = 500

  validates_presence_of :name, :price, :minimum_period, :subcategory_id, :deliver_ids, :aasm_state, :lender
  validates_presence_of :address, if: :delivers_include_face?
  validates_numericality_of :deliver_fee, equal_to: 0, unless: :delivers_include_non_face?
  validate :profile_bank_info_presented, if: :delivers_include_non_face?

  belongs_to :lender, class_name: "User", foreign_key: "user_id"
  belongs_to :category
  belongs_to :subcategory
  belongs_to :city

  has_many :records, -> { order(started_at: :desc) }, class_name: 'Record', foreign_key: 'item_id'
  has_many :borrowers, through: :records, source: :user
  has_many :reviews, through: :records, source: :reviews

  has_many :collect_relationships, class_name: "ItemCollection", foreign_key: "item_id", dependent: :destroy
  has_many :collectors, through: :collect_relationships, source: :user

  has_many :pictures, class_name: 'Attachment', as: :attachable, dependent: :destroy

  has_many :item_deliver, dependent: :destroy
  has_many :delivers, through: :item_deliver

  has_many :items_selections, dependent: :destroy
  has_many :selections, through: :items_selections
  accepts_nested_attributes_for :selections

  enum period: [ :每日, :每月, :每年 ]

  geocoded_by :address, if: ->(obj){ obj.address.present? and obj.address_changed? }

  after_validation :geocode
  before_save :set_category_and_price, :set_city

  scope :search_and_sort, ->(params) do
    includes(:pictures, :city, :collectors, lender: [{ profile: :avatar}])
      .opening.record_not_overlaps(params[:started_at], params[:ended_at])
      .price_range(params[:price_min], params[:price_max])
      .search_by(params[:query])
      .city_at(params[:city])
      .subcategory_is(params[:subcategory])
      .has_selections(params[:selections])
      .the_sort(params[:sort])
      .page(params[:page])
  end
  scope :search_by, -> (query) { where(search_criteria(query)) if query.present? }
  scope :city_at, -> (city_id) { where(city_id: city_id) if city_id.present? }
  scope :subcategory_is, -> (subcategory_id) { where(subcategory_id: subcategory_id) if subcategory_id.present? }

  scope :price_range, -> (min, max) { price_greater_than(min).price_less_than(max) }
  scope :price_greater_than, -> (min) { where('price >= ?', min) if min.present? and min != PRICE_MIN }
  scope :price_less_than, -> (max) { where('price <= ?', max) if max.present? and max != PRICE_MAX }

  scope :has_selections, ->(selection_ids) do
    if selection_ids.present?
      items = joins(:items_selections)
      vector_groups_selections = Selection.where(id: selection_ids).group_by(&:vector)

      intersection = []
      vector_groups_selections.each_with_index {|(vector, selections), index|
        if index == 0
          intersection = items.where(items_selections: { selection_id: selections })
        else
          intersection &= items.where(items_selections: { selection_id: selections })
        end
      }
      items.where(id: intersection).uniq
    end
  end

  scope :record_overlaps, ->(started_at, ended_at) do
    where(id: Record.select(:id, :item_id).overlaps(started_at, ended_at).pluck(:item_id))
  end
  scope :record_not_overlaps, ->(started_at, ended_at) do
    where.not(id: record_overlaps(started_at, ended_at)) if started_at.present? and ended_at.present?
  end

  scope :the_sort, ->(sort_param) do
    sort_param = (Item.sort_list.include? sort_param) ? sort_param : 'recent'
    case sort_param
    when 'recent'
      order('items.created_at').reverse_order
    when 'cheap'
      order('price')
    when 'expensive'
      order('price').reverse_order
    end
  end

  scope :cover_pictures_urls, -> { all.map{ |i| i.cover_picture.image.url } }

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

  def set_address(user)
    self.address = user.profile.address
  end

  def profile_bank_info_presented
    unless lender.profile.bank_info_present?
      errors.add(:delivers, '請先填寫匯款資訊')
    end
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

  def self.sort_list
    [ 'recent', 'cheap', 'expensive' ]
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

  def booked_dates
    dates = records.actived
                   .where('ended_at > ?', Time.now)
                   .collect { |record| (record.started_at.to_date .. (record.ended_at).to_date).map(&:to_s) }
    dates << Time.now.yesterday.to_date.to_s
    dates.flatten
  end

  def selections_checked
    selections.select(:id).map { |s| s.id }
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
end
