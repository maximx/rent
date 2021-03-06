class Review < ActiveRecord::Base
  validates_presence_of :content, :rate, :user_role, :user_id, :judger_id, :record_id

  belongs_to :judger, class_name: "User", foreign_key: "judger_id"
  belongs_to :user
  belongs_to :record

  # 負評、好評、未評
  enum rate: [ :bad, :good, :notyet ]
  enum user_role: [ :lender, :borrower ]

  self.per_page = 5

  before_validation :set_user_and_role

  # notyet is default
  def self.rates_radio_collections
    rates.slice(:good, :bad).keys.map do |v|
      [ human_attribute_name("rate.#{v}"), v ]
    end
  end

  def human_rate
    self.class.human_attribute_name("rate.#{rate}")
  end

  def item
    self.record.item
  end

  def notify_ask_for_review_subject
    [
      judger.account,
      '對',
      item.name,
      '承租評價為',
      human_rate,
      '並邀請您為他評價'
    ].join(' ')
  end

  private

    def set_user_and_role
      if "lender" == judger.role_of(record)
        self.user_role = "borrower"
        self.user = record.borrower
      elsif "borrower" == judger.role_of(record)
        self.user_role = "lender"
        self.user = record.lender
      end
    end
end
