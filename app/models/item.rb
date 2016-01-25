class Item < ActiveRecord::Base
  include AASM
  include CurrencyPrice
  include BookedDates

  attr_accessor :file # item import file

  self.per_page = 20
  PRICE_MIN = 0
  PRICE_MAX = 2000

  validates_presence_of :name, :price, :period, :minimum_period, :subcategory_id, :aasm_state, :lender
  validates_numericality_of :deliver_fee, equal_to: 0, unless: :delivers_include_non_face?
  validate :profile_bank_info_presented, if: :delivers_include_non_face?

  belongs_to :lender, class_name: "User", foreign_key: "user_id"
  belongs_to :category
  belongs_to :subcategory

  has_many :records
  has_many :reviews, through: :records

  has_many :collect_relationships, class_name: "ItemCollection", foreign_key: "item_id", dependent: :destroy
  has_many :collectors, through: :collect_relationships, source: :user

  has_many :pictures, class_name: 'Attachment', as: :attachable, dependent: :destroy

  has_many :items_selections, dependent: :destroy
  has_many :selections, through: :items_selections
  accepts_nested_attributes_for :selections

  has_many :delivers, through: :lender

  # changed with record.item_period, shopping_cart_item.period
  enum period: { per_time: 0, per_day: 1 }

  before_save :set_category_and_price

  scope :search_and_sort, ->(params) do
    includes(:pictures, :collectors, lender: [{ profile: :avatar}])
      .opening
      .record_not_overlaps(params[:started_at], params[:ended_at])
      .price_range(params[:price_min], params[:price_max])
      .search_by(params[:query])
      .subcategory_is(params[:subcategory])
      .has_selections(params[:selections])
      .the_sort(params[:sort])
      .page(params[:page])
  end
  scope :search_by, -> (query) { where(search_criteria(query)) if query.present? }
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
    if started_at.present? and ended_at.present?
      where(id: Record.select(:id, :item_id).overlaps(started_at, ended_at).pluck(:item_id))
    end
  end
  scope :record_not_overlaps, ->(started_at, ended_at) do
    if started_at.present? and ended_at.present?
      where.not(id: record_overlaps(started_at, ended_at))
    end
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

  def valid_attributes?(attrs = {})
    valid?
    attrs.each {|attr| return false if errors.has_key? attr.to_sym }
    true
  end

  def self.import(user, importer_params)
    sheet = open_sheet( importer_params.delete(:file) )
    header = sheet_header(sheet.row(1))
    vector_selections = sheet_vector_selections(sheet,
                                                vector_columns: header[:vector][:columns],
                                                subcategory_id: importer_params[:subcategory_id],
                                                user_id: user.id)
    errors = []
    (2..sheet.last_row).each do |i|
      sheet_row = sheet.row(i)
      item_attributes = []
      selection_name = []
      header[:item][:columns].each {|i| item_attributes << sheet_row[i - 1] }
      header[:vector][:columns].each {|i| selection_name << sheet_row[i - 1] }

      # item selections
      selection_ids = []
      vector_selection_names = Hash[ [header[:vector][:name], selection_name].transpose ]
      vector_selection_names.each do |v_name, s_name|
        s_name.strip! unless s_name.nil?
        selection_ids << vector_selections[v_name][s_name] if s_name.present?
      end

      row = Hash[ [header[:item][:name], item_attributes].transpose ].symbolize_keys
      item_params = importer_params.merge(row)
      item_params[:selection_ids] = selection_ids
      item_params[:deposit] ||= 0
      item_params[:minimum_period] ||= 1

      item = user.items.build item_params
      if item.valid?
        item.close
        item.save!
      else
        message = item.errors.messages.values.join(',')
        errors << I18n.t('activerecord.errors.models.item.import.fail', i: i, message: message)
      end
    end
    errors
  end

  def select_delivers
    delivers.map{|d| [d.name, d.id, {'data-deliver_fee': (d.remit_needed? ? deliver_fee : 0), 'data-send_home': d.send_home?}]}
  end

  def profile_bank_info_presented
    errors.add(:deliver_fee, :bank_info_blank) unless lender.profile.bank_info_present?
  end

  def period_without_per
    period_i18n.slice(1)
  end

  def price_period
    "#{currency_price}/#{period_i18n}"
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

  def selections_checked
    selections.select(:id).map { |s| s.id }
  end

  def delivers_include_non_face?
    lender.delivers_include_non_face?
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
    "concat(items.name, ifnull(items.description, '')) like ?"
  end

  private
    def self.open_sheet(file)
      ext_list = ['.csv', '.xls', '.xlsx']
      if ext_list.include?(File.extname(file.original_filename))
        Roo::Spreadsheet.open(file.path)
      else
        raise "Unknown file type: #{file.original_filename}"
      end
    end

    # get all sheet vector, selection
    def self.sheet_vector_selections(sheet, params = {})
      vector_selections = {}
      params[:vector_columns].each do |i|
        vector_name = sheet.column(i).first
        vector_selections[vector_name] = {}
        selection_names = sheet.column(i).drop(1).uniq

        vector = Vector.find_or_create_by_name(subcategory_id: params[:subcategory_id],
                                               user_id: params[:user_id],
                                               name: vector_name)
        selections = Selection.find_or_create_by_names(vector_id: vector.id,
                                                       user_id: params[:user_id],
                                                       names: selection_names)
        selections.each {|s| vector_selections[vector_name][s.name] = s.id }
      end
      vector_selections
    end

    def self.sheet_header(row)
      column_names = []
      column_indexs = []
      vector_names = []
      vector_indexs = []
      item_label = I18n.t('simple_form.labels.item')

      row.each_with_index do |v, i|
        item_column = item_label.key(v)
        if item_column.present?
          row[i] = item_column
          column_indexs << (i + 1)
          column_names << item_column
        else
          vector_indexs << (i + 1)
          vector_names << v
        end
      end

      { item: { name: column_names, columns: column_indexs },
        vector: { name: vector_names, columns: vector_indexs } }
    end
end
