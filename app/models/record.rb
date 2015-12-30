class Record < ActiveRecord::Base
  include AASM
  include CurrencyPrice

  validates_presence_of :item_id, :borrower, :started_at, :ended_at, :aasm_state, :deliver_id
  validate :start_end_date, :not_overlap

  belongs_to :borrower, polymorphic: true
  belongs_to :item
  belongs_to :deliver
  belongs_to :order
  has_one :lender, through: :item

  has_many :reviews
  has_many :judgers, through: :reviews

  has_many :record_state_logs, class_name: 'RecordStateLog', foreign_key: 'record_id', dependent: :destroy

  self.per_page = 10

  before_validation :set_ended_at
  before_save :set_item_attributes
  after_save :save_booking_state_log, :send_payment_message

  scope :overlaps, ->(started_at, ended_at) do
    where("(TIMESTAMPDIFF(SECOND, started_at, ?) * TIMESTAMPDIFF(SECOND, ?, ended_at)) >= 0", ended_at, started_at)
      .actived
  end
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

  def overlaps?
    overlaps.exists?
  end

  def overlaps
    item.records.where.not(id: id || -1).overlaps(started_at, ended_at)
  end

  def as_json(options={})
    {
      id: id,
      title: "#{borrower.account} - #{ApplicationController.helpers.render_item_name(item, 15)}",
      start: started_at,
      end: ended_at,
      url: Rails.application.routes.url_helpers.item_record_path(item, id)
    }
  end

  #可查閱
  def viewable_by?(user)
    user && [lender, borrower].include?(user)
  end

  #可修改
  def editable_by?(user)
    user and booking? and (
      borrower == user or
      ( lender == user and borrower.is_customer? )
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

  # 物品為郵件寄送，且有金額需結算
  def remit_needed?
    total_price > 0 and delivery_needed?
  end

  def delivery_needed?
    deliver.name != '面交自取'
  end

  def emailable?
    borrower.email.present?
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

  def ended_date
    ended_at.to_date
  end

  def update_order
    order = borrower.orders.create(started_at: started_at, ended_at: ended_date, price: price)
    update(order: order)
  end

  private
    #只有日期 ended_at + 1.day，為整點減去一秒避免 overlap
    def set_ended_at
      self.ended_at += (1.day - 1.second) if self.new_record? and ended_at.present?
    end

    def set_item_attributes
      if self.new_record?
        self.item_price ||= item.price
        self.rent_days = ((ended_at - started_at).to_f / (24 * 60 * 60)).ceil
        self.item_deposit = item.deposit
        self.deliver_fee ||= (deliver == Deliver.face_to_face) ? 0 : item.deliver_fee

        self.price = rent_days * item_price
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

    def send_payment_message
      RecordMailer.send_payment_message(self).deliver if remit_needed? and booking? and emailable?
    end
end
