class Review < ActiveRecord::Base
  validates_presence_of :content, :rate, :user_role, :user_id, :judger_id, :rent_record_id

  belongs_to :judger, class_name: "User", foreign_key: "judger_id"
  belongs_to :user
  belongs_to :rent_record

  # 負評、好評、未評
  enum rate: [ :bad, :good, :notyet ]
  enum user_role: [ :lender, :borrower ]

  before_validation :set_user_and_role

  # notyet is default
  def self.rates_radio_collections
    rates.slice(:good, :bad).keys.map do |v|
      [ Review.human_attribute_name("rate.#{v}"), v ]
    end
  end

  private

    def set_user_and_role
      if "lender" == judger.role_of(rent_record)
        self.user_role = "borrower"
        self.user = rent_record.borrower
      elsif "borrower" == judger.role_of(rent_record)
        self.user_role = "lender"
        self.user = rent_record.item.lender
      end
    end

end
