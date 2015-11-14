class Profile < ActiveRecord::Base
  extend I18nMessage

  validates_presence_of :name, :address
  validates :bank_code, length: { is: 3 }, inclusion: Bank.all.map(&:code), allow_blank: true
  validates_presence_of :bank_account, if: :bank_code?
  validates :phone, uniqueness: true, allow_blank: true

  belongs_to :user, polymorphic: true
  belongs_to :bank, class_name: 'Bank', foreign_key: 'bank_code'

  has_one :avatar, class_name: 'Picture', as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :avatar

  geocoded_by :address, if: ->(obj){ obj.address.present? and obj.address_changed? }

  after_validation :geocode
  before_update :generate_confirmation_token, if: :phone_changed?
  after_update :send_confirmation_instructions, if: :phone_changed?

  def logo_name
    name || user.account
  end

  def bank_info_present?
    bank_code.present? and bank_account.present?
  end

  def phone_confirmed?
    !!confirmed_at
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

  private

    def generate_confirmation_token
      self.confirmed_at = nil
      self.confirmation_sent_at = Time.now
      self.confirmation_token = 4.times.map { rand 10 }.join
    end

    def send_confirmation_instructions
      sms_url = 'http://smexpress.mitake.com.tw:9600/SmSendGet.asp?'
      msg = "#{self.name}您好，這是#{Rent::SITE_NAME}的手機驗證簡訊，驗證碼：#{self.confirmation_token}，如您非本人請忽略此訊息"
      query = {
        username: '0928479770',
        password: 'ju2li3us',
        dstaddr: self.phone,
        smbody: msg,
        encoding: 'UTF8'
      }

      uri = URI.parse(sms_url + query.to_query)
      request = Net::HTTP::Get.new uri.to_s
      response = Net::HTTP.start(uri.host, uri.port) { |http| http.request(request) }
    end
end
