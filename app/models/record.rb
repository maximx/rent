class Record < ActiveRecord::Base
  include AASM
  include CurrencyPrice
  include DatetimeOverlaps

  self.per_page = 10

  validates_presence_of :item_id, :borrower, :started_at, :ended_at, :aasm_state, :deliver_id
  validates_presence_of :send_period, if: ->(obj){ obj.deliver.present? and obj.deliver.send_home? }
  validates :deliver_id, inclusion: { in: ->(obj){ obj.lender.delivers.pluck(:id) } }
  validate :start_end_date, :not_overlap, :borrower_lender_customers, :borrower_info_present

  belongs_to :borrower, polymorphic: true
  belongs_to :item
  belongs_to :deliver
  belongs_to :order
  has_one :lender, through: :item

  has_many :reviews
  has_many :judgers, through: :reviews

  has_many :record_state_logs, class_name: 'RecordStateLog', foreign_key: 'record_id', dependent: :destroy

  # changed with item.period, shopping_cart_item.period
  enum item_period: {per_time: 0, per_day: 1}
  enum send_period: {morning: 0, afternoon: 1, evening: 2}

  geocoded_by :address

  after_initialize :set_free_days, if: :new_record?
  after_validation :set_address, if: ->(obj){ obj.deliver and obj.new_record? }
  after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }
  before_create :set_item_attributes, if: :new_record?
  after_create :save_booking_state_log

  scope :actived, -> { where.not(aasm_state: "withdrawed") }
  scope :recent, -> { order(:created_at).reverse_order }

  aasm no_direct_assignment: true do
    state :booking, initial: true
    state :remitted, before_enter: :create_record_state_log
    state :delivering, before_enter: :create_record_state_log
    state :renting, before_enter: :create_record_state_log
    state :withdrawed, before_enter: :create_record_state_log
    state :returned, before_enter: :create_record_state_log

    event :remit, guards: [ :remit_needed? ] do
      transitions from: :booking, to: :remitted
    end

    event :delivery, guards: [ :delivery_needed? ] do
      transitions from: :booking, to: :delivering, unless: :remit_needed?
      transitions from: :remitted, to: :delivering, guards: :remit_needed?
    end

    event :rent do
      # 已預訂，免付款, 自取
      transitions from: :booking, to: :renting, unless: [ :remit_needed?, :delivery_needed? ]
      # 已付款，自取
      transitions from: :remitted, to: :renting, unless: [ :delivery_needed? ]
      transitions from: :delivering, to: :renting #TODO: whenver task
    end

    event :withdraw do
      transitions from: :booking, to: :withdrawed
    end

    event :return do
      transitions from: :renting, to: :returned
    end
  end

  def start_end_date
    if booking? and ended_at and started_at
      if ended_at < started_at or started_at < Time.now
        errors[:started_at] << I18n.t('activerecord.errors.models.record.attributes.started_at.bad_started_at')
      end

      # 在 set_ended_at 時減去 1 秒 會不滿 1 日
      if (ended_at - started_at + 1.second) < item.minimum_period.days
        errors[:ended_at] << I18n.t(
          'activerecord.errors.models.record.attributes.started_at.bad_period',
          period: "#{item.minimum_period} #{item.period_without_per}"
        )
      end
    end
  end

  def not_overlap
    errors[:ended_at] << I18n.t('activerecord.errors.models.record.attributes.ended_at.overlap') if overlaps? && booking?
  end

  def borrower_lender_customers
    if borrower_type == 'Customer' and !lender.customers.pluck(:id).include?(borrower_id)
      errors.add :borrower, :not_customer
    end
  end

  def borrower_info_present
    if borrower_info_needed? and !borrower.profile.detail_info_present?
      errors.add :deliver_id, :detail_info_blank
    end
  end

  def overlaps?
    overlaps.exists?
  end

  def overlaps
    item.records.where.not(id: id || -1).overlaps(started_at, ended_at)
  end

  def name
    I18n.t('activerecord.methods.record.name',
           order_id: order_id,
           name: lender.logo_name)
  end

  def as_json(options={})
    {
      id: id,
      title: json_title(options[:user]),
      start: started_at,
      end: ended_at,
      url: Rails.application.routes.url_helpers.item_record_path(item, id)
    }
  end

  def json_title(user)
    ability = Ability.new(user)
    borrower_name = borrower.logo_name
    borrower_name = controller_helpers.mask(borrower_name) if ability.cannot?(:show, self)
    I18n.t('activerecord.methods.record.json_title',
           name: borrower_name,
           days: rent_days,
           datetime: controller_helpers.render_datetime(created_at))
  end

  #可查閱
  def viewable_by?(user)
    user and [lender, borrower].include?(user)
  end

  #可修改
  def editable_by?(user)
    user and booking? and (
      borrower == user or
      (lender == user and borrower.is_customer?)
    )
  end

  def review_of_user(user)
    rv = reviews.where(user_id: user.id).first
    rv ||= user.reviews.build
  end

  def review_of_judger(user)
    rv = reviews.where(judger_id: user.id).first
    rv ||= user.reviews.build
  end

  def borrower_info_needed?
    lender.borrower_info_provide or (deliver and deliver.address_needed?)
  end

  # 物品為郵件寄送，且有金額需結算
  def remit_needed?
    total_price > 0 and deliver.remit_needed?
  end

  def delivery_needed?
    deliver.delivery_needed?
  end

  def total_price
    price + item_deposit + deliver_fee
  end

  def next_states
    aasm.states(permitted: true).map(&:name)
  end

  def all_permitted_states
    states = aasm.states.map(&:name)
    states.delete_if { |state| state == :withdrawed } unless aasm.current_state == :withdrawed
    states.delete(:remitted) unless remit_needed?
    states.delete(:delivering) unless delivery_needed?
    states.delete_if { |state| ![:withdrawed, :booking].include? state } if aasm.current_state == :withdrawed
    states
  end

  def pending_states
    all_permitted_states - record_state_logs.map { |log| log.id && log.aasm_state.to_sym }
  end

  def notify_booking_subject
    [
      borrower.account,
      '於',
      ApplicationController.helpers.render_datetime_period(self, :tw),
      I18n.t("activerecord.attributes.record.aasm_state.#{aasm.current_state}"),
      item.name
    ].join(' ')
  end

  def update_order
    order = borrower.orders.create(
      started_at: started_at,
      ended_at: ended_date,
      deposit: item_deposit,
      deliver_fee: deliver_fee,
      price: price
    )
    update(order: order)
  end

  def sibling_records
    order.records_of(lender).where.not(id: id)
  end

  private
    def set_free_days
      self.free_days ||= lender.free_days
    end

    def set_address
      self.address = deliver.address_needed? ? borrower.profile.address : lender.profile.address
    end

    def set_item_attributes
      self.item_price ||= item.price
      self.item_period ||= item.period
      self.item_deposit ||= item.deposit
      self.deliver_fee ||= deliver.delivery_needed? ? item.deliver_fee : 0
      self.rent_days = ((ended_at - started_at).to_f / (24 * 60 * 60)).ceil
      self.price = valid_rent_days * item_price
    end

    def valid_rent_days
      if per_time? #每次
        1
      elsif rent_days > free_days #正常的承租天數
        rent_days - free_days
      else
        0 #有問題的，算零天
      end
    end

    def create_record_state_log(borrower, log_params = {})
      log_params[:aasm_state] = (record_state_logs.empty?) ? aasm.current_state : aasm.to_state
      attachments = log_params.delete :attachments

      log = record_state_logs.build(log_params)
      log.borrower = borrower

      if log.save and attachments
        attachments.each { |attachment| log.attachments.create file: attachment }
      end
    end

    def save_booking_state_log
      create_record_state_log(borrower) if record_state_logs.empty?
    end

    def controller_helpers
      ApplicationController.helpers
    end
end
