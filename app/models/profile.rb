class Profile < ActiveRecord::Base
  extend I18nMessage

  validates_presence_of :name, :address
  validates :bank_code, length: { is: 3 }, inclusion: Bank.all.map(&:code), allow_blank: true
  validates_presence_of :bank_account, if: :bank_code?

  belongs_to :user
  belongs_to :city
  belongs_to :bank, class_name: 'Bank', foreign_key: 'bank_code'

  has_one :picture, as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :picture

  before_update :generate_confirmation_token, if: :phone_changed?
  after_update :send_confirmation_instructions, if: :phone_changed?

  def city_address_json
    { city_id: city_id, address: address }.to_json
  end

  def validates
    errors = []
    [ 'name', 'address' ].each do |attr|
      errors << self.class.i18n_simple_form_label(attr) if self.send(attr).blank?
    end

    { errors: errors, message: "請完成#{errors.join('、')}的資料填寫" }
  end

  def phone_confirmed
    self.confirmation_token = nil
    self.confirmation_sent_at = nil
    self.confirmed_at = Time.now
    self.save
  end

  def phone_confirmed?
    !!confirmed_at
  end

  private

    def generate_confirmation_token
      self.confirmed_at = nil
      self.confirmation_sent_at = Time.now
      self.confirmation_token = 4.times.map { rand 10 }.join
    end

    def send_confirmation_instructions
      logger.info '-------- 寄簡訊 --------'
    end
end
