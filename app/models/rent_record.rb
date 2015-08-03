class RentRecord < ActiveRecord::Base
  include AASM
  include CurrencyPrice
  include I18nMessage

  validates_presence_of :item_id, :user_id, :started_at, :ended_at, :aasm_state
  validate :start_end_date
  validate :not_overlap

  belongs_to :borrower, class_name: "User", foreign_key: "user_id"
  belongs_to :item
  has_many :reviews

  self.per_page = 10

  before_save :set_price

  scope :overlaps, ->(started_at, ended_at) do
    where("(TIMESTAMPDIFF(MINUTE, started_at, ?) * TIMESTAMPDIFF(MINUTE, ?, ended_at)) >= 0", ended_at, started_at)
      .actived
  end
  scope :actived, -> { where.not(aasm_state: "withdrawed") }
  scope :booking_order, -> { order(:booking_at).reverse_order }

  aasm no_direct_assignment: true do
    state :booking, initial: true, before_enter: :set_state_updated_at
    state :renting, before_enter: :set_state_updated_at
    state :withdrawed, before_enter: :set_state_updated_at
    state :returned, before_enter: :set_state_updated_at

    event :rent do
      transitions from: :booking, to: :renting
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
        errors[:started_at] << i18n_message("started_at.bad_started_at")
      end

      if (ended_at - started_at) < item.minimum_period.days
        errors[:ended_at] << i18n_message("started_at.bad_period", period: "#{item.minimum_period} #{item.period}")
      end
    end
  end

  def not_overlap
    errors[:ended_at] << i18n_message("ended_at.overlap") if overlaps? && booking?
  end

  def overlaps?
    overlaps.exists?
  end

  def overlaps
    item.rent_records.where.not(id: id || -1).overlaps(started_at, ended_at)
  end

  #gmaps4rails
  def as_json(options={})
    {
      id: id,
      title: "(#{ApplicationController.helpers.render_item_name(item, 15)}…) - #{borrower.account}",
      start: started_at,
      end: ended_at,
      url: Rails.application.routes.url_helpers.item_rent_record_path(item, id)
    }
  end

  # state changed calendar event
  def aasm_state_dates_json
    dates_json = [ as_json ]

    aasm.states.each do |state|
      attribute_name = state.to_s + "_at"
      state_changed_at = self.send( attribute_name )

      unless state_changed_at.nil?
        dates_json << {
          id: state.name,
          title: state.human_name,
          start: state_changed_at,
          end: state_changed_at + 1.day,
          color: state_color(state.name)
        }
      end
    end

    dates_json
  end

  #可查閱
  def viewable_by?(user)
    user && [item.lender, borrower].include?(user)
  end

  #可修改
  def editable_by?(user)
    user && borrower == user && booking?
  end

  #可評價
  def can_review_by?(user)
    user && viewable_by?(user) && returned? && !reviews.pluck(:judger_id).include?(user.id)
  end

  def can_ask_review_by?(user)
    user && is_reviewed_by_judger?(user) && can_review_by?(review_of_judger(user).user)
  end

  #可確認出租
  def can_rent_by?(user)
    user && booking? && item.lender == user
  end

  #可確認歸還
  def can_return_by?(user)
    renting? && item.lender == user
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

  def rent_days
    ((ended_at - started_at).to_f / (24 * 60 * 60)).ceil
  end

  def lender
    self.item.lender
  end

  protected

    def set_price
      self.price =  rent_days * item.price
    end

  private

    def set_state_updated_at
      attribute_name = aasm.to_state.to_s + "_at="
      attribute_name = aasm.current_state.to_s + "_at=" if aasm.to_state.nil?
      self.send(attribute_name, Time.now)
    end

    def state_color(state)
      colors = {
        booking: :blue, renting: :green,
        withdrawed: :gray, returned: :red
      }
      colors[state.to_sym]
    end
end
