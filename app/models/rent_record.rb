class RentRecord < ActiveRecord::Base
  include AASM
  include CurrencyPrice
  extend I18nMessage

  validates_presence_of :item_id, :borrower, :started_at, :ended_at, :aasm_state, :deliver_id
  validate :start_end_date, :not_overlap, :borrower_not_lender

  belongs_to :borrower, polymorphic: true
  belongs_to :item
  belongs_to :deliver, required: true
  has_many :reviews
  has_many :rent_record_state_logs, class_name: 'RentRecordStateLog', foreign_key: 'rent_record_id'

  self.per_page = 10

  before_save :set_item_attributes, :set_ended_at
  after_save :save_booking_state_log, :send_payment_message

  scope :overlaps, ->(started_at, ended_at) do
    where("(TIMESTAMPDIFF(MINUTE, started_at, ?) * TIMESTAMPDIFF(MINUTE, ?, ended_at)) >= 0", ended_at, started_at)
      .actived
  end
  scope :actived, -> { where.not(aasm_state: "withdrawed") }
  scope :rencent, -> { order(:created_at).reverse_order }

  aasm no_direct_assignment: true do
    state :booking, initial: true
    state :remitted, before_enter: :create_rent_record_state_log
    state :delivering, before_enter: :create_rent_record_state_log
    state :renting, before_enter: :create_rent_record_state_log
    state :withdrawed, before_enter: :create_rent_record_state_log
    state :returned, before_enter: :create_rent_record_state_log

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
    if booking? && ended_at && started_at
      if ended_at < started_at || started_at < Time.now
        errors[:started_at] << self.class.i18n_activerecord_error("started_at.bad_started_at")
      end

      if (ended_at - started_at) < item.minimum_period.days
        errors[:ended_at] << self.class.i18n_activerecord_error("started_at.bad_period",
                                                                period: "#{item.minimum_period} #{item.period}")
      end
    end
  end

  def not_overlap
    errors[:ended_at] << self.class.i18n_activerecord_error("ended_at.overlap") if overlaps? && booking?
  end

  def overlaps?
    overlaps.exists?
  end

  def overlaps
    item.rent_records.where.not(id: id || -1).overlaps(started_at, ended_at)
  end

  def borrower_not_lender
    errors[:started_at] << '您沒有權限' unless rentable_by?(borrower)
  end

  #gmaps4rails
  def as_json(options={})
    {
      id: id,
      title: "#{borrower.account} - #{ApplicationController.helpers.render_item_name(item, 15)}",
      start: started_at,
      end: ended_at,
      url: Rails.application.routes.url_helpers.item_rent_record_path(item, id)
    }
  end

  # state changed calendar event
  def aasm_state_dates_json
    dates_json = [ as_json ]

    dates_json << initial_state_date_json

    rent_record_state_logs.each do |log|
      dates_json << {
        id: log.aasm_state,
        title: self.class.i18n_activerecord_attribute("aasm_state.#{log.aasm_state}"),
        start: log.created_at,
        end: log.created_at + 1.minute,
        color: state_color(log.aasm_state)
      }
    end

    dates_json
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

  def rentable_by?(user)
    item.rentable_by? user
  end

  #可評價
  def can_review_by?(user)
    user && viewable_by?(user) && returned? && !reviews.pluck(:judger_id).include?(user.id)
  end

  def can_ask_review_by?(user)
    user && is_reviewed_by_judger?(user) && can_review_by?(review_of_judger(user).user)
  end

  def can_remit_by?(user)
    user && editable_by?(user) && remit_needed? && booking?
  end

  def can_delivery_by?(user)
    user && delivery_needed? && lender == user &&
      ( ( booking? && !remit_needed? ) || ( remitted? && remit_needed? ) )
  end

  #可確認出租
  def can_rent_by?(user)
    user && lender == user &&
      ( delivering? || (!delivery_needed? && ( ( booking? && !remit_needed? ) || remitted? ) ) )
  end

  #可確認歸還
  def can_return_by?(user)
    renting? && lender == user
  end

  #可取消預訂
  def can_withdraw_by?(user)
    booking? && editable_by?(user)
  end

  def review_of_user(user)
    rv = reviews.where(user_id: user.id).first
    rv ||= user.reviews.build
  end

  def review_of_judger(user)
    rv = reviews.where(judger_id: user.id).first
    rv ||= user.reviews.build
  end

  def is_reviewed_by_judger?(user)
    reviews.where(judger_id: user.id).exists?
  end

  # 物品為郵件寄送，且有金額需結算
  def remit_needed?
    total_price > 0 and delivery_needed?
  end

  def delivery_needed?
    deliver.name != '面交自取'
  end

  def lender
    self.item.lender
  end

  def total_price
    price + item_deposit + deliver_fee
  end

  def next_states
    aasm.states(permitted: true).map(&:name)
  end

  def all_permitted_states
    states = aasm.states.map(&:name)
    states.delete(:remitted) unless remit_needed?
    states.delete(:delivering) unless delivery_needed?
    states.delete_if { |state| state == :withdrawed }
  end

  def pending_states
    all_permitted_states - rent_record_state_logs.map { |log| log.id && log.aasm_state.to_sym }
  end

  def notify_booking_subject
    [
      borrower.account,
      '於',
      ApplicationController.helpers.render_datetime_period(self, :tw),
      self.class.i18n_activerecord_attribute("aasm_state.#{aasm.current_state}"),
      item.name
    ].join(' ')
  end

  def emailable?
    borrower.email.present?
  end

  protected

    def set_item_attributes
      self.item_price = item.price
      self.rent_days = ((ended_at - started_at).to_f / (24 * 60 * 60)).ceil
      self.item_deposit = item.deposit
      self.deliver_fee = (deliver == Deliver.face_to_face) ? 0 : item.deliver_fee

      self.price = rent_days * item_price
    end

    #為整點 則減去一秒 避免 overlap
    def set_ended_at
      self.ended_at -= 1.second if self.ended_at.strftime('%H%M%S') == '000000'
    end

    def save_booking_state_log
      create_rent_record_state_log(borrower) if rent_record_state_logs.empty?
    end

    def send_payment_message
      RentRecordMailer.send_payment_message(self).deliver if remit_needed? and booking? and emailable?
    end

  private

    def create_rent_record_state_log(borrower, params = {})
      params[:aasm_state] = (rent_record_state_logs.empty?) ? aasm.current_state : aasm.to_state
      log = rent_record_state_logs.build(params)
      log.borrower = borrower
      log.save
    end

    def initial_state_date_json
      initial_state = self.class.aasm.initial_state

      {
        id: initial_state,
        title: self.class.i18n_activerecord_attribute("aasm_state.#{initial_state}"),
        start: created_at,
        end: created_at + 1.minute,
        color: state_color(initial_state)
      }
    end

    def state_color(state)
      colors = {
        booking: :blue, renting: :green,
        remitted: :brown, delivering: :yellow,
        withdrawed: :gray, returned: :red
      }
      colors[state.to_sym]
    end
end
