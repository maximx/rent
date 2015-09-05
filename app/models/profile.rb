class Profile < ActiveRecord::Base
  extend I18nMessage

  belongs_to :user
  has_one :picture, as: :imageable, dependent: :destroy
  belongs_to :city
  belongs_to :bank, class_name: 'Bank', foreign_key: 'bank_code'

  validates_presence_of :name, :city_id, :address
  validates :bank_code, length: { is: 3 }, inclusion: Bank.all.map(&:code), allow_blank: true
  validates_presence_of :bank_account, if: :bank_code?

  accepts_nested_attributes_for :picture

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
end
