class OrderLender < ActiveRecord::Base
  include AASM

  validates_presence_of :order_id, :lender_id, :deliver_id
  validates :deliver_id, inclusion: { in: ->(obj){ obj.lender.delivers.pluck(:id) } }

  belongs_to :order
  belongs_to :lender, class_name: 'User'
  belongs_to :deliver

  has_many :records
  has_many :order_lender_logs, dependent: :destroy

  aasm no_direct_assignment: true do
    state :booking, initial: true
    state :remitted
    state :delivering
    state :renting
    state :withdrawed
    state :returned

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
end
