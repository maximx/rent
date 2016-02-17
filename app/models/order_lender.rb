class OrderLender < ActiveRecord::Base
  include AASM

  validates_presence_of :order_id, :lender_id, :deliver_id
  validates :deliver_id, inclusion: { in: ->(obj){ obj.lender.delivers.pluck(:id) } }

  belongs_to :order
  belongs_to :lender, class_name: 'User'
  belongs_to :deliver

  has_many :records
  has_many :order_lender_logs, dependent: :destroy

  delegate :borrower, to: :order

  after_create :create_booking_log

  aasm no_direct_assignment: true do
    state :booking,    initial: true
    state :remitted,   before_enter: :create_log
    state :delivering, before_enter: :create_log
    state :renting,    before_enter: :create_log
    state :withdrawed, before_enter: :create_log
    state :returned,   before_enter: :create_log

    event :remit, guards: [ :remit_needed? ] do
      transitions from: :booking, to: :remitted
    end

    event :delivery, guards: [ :delivery_needed? ] do
      transitions from: :booking,  to: :delivering, unless: :remit_needed?
      transitions from: :remitted, to: :delivering, guards: :remit_needed?
    end

    event :rent do
      # 已預訂，免付款, 自取
      transitions from: :booking,    to: :renting, unless: [ :remit_needed?, :delivery_needed? ]
      # 已付款，自取
      transitions from: :remitted,   to: :renting, unless: [ :delivery_needed? ]
      transitions from: :delivering, to: :renting #TODO: whenver task
    end

    event :withdraw do
      transitions from: :booking, to: :withdrawed
    end

    event :return do
      transitions from: :renting, to: :returned
    end
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

  def remit_needed?
    total_price > 0 and deliver.remit_needed?
  end

  def delivery_needed?
    deliver.delivery_needed?
  end

  def total_price
    price + deposit + deliver_fee
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
    all_permitted_states - order_lender_logs.map { |log| log.id and log.aasm_state.to_sym }
  end

  private
    def create_log(actor, log_params = {})
      log_params[:aasm_state] = (order_lender_logs.empty?) ? aasm.current_state : aasm.to_state
      log_params[:user]       = actor
      attachments             = log_params.delete :attachments

      log = order_lender_logs.build(log_params)

      if log.save and attachments
        attachments.each { |attachment| log.attachments.create(file: attachment) }
      end
    end

    def save_booking_state_log
      create_log(borrower) if order_lender_logs.empty?
    end
end
