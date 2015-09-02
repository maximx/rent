class Profile < ActiveRecord::Base
  belongs_to :user
  has_one :picture, as: :imageable, dependent: :destroy
  belongs_to :city

  validates_presence_of :name, :city_id, :address
  validates_length_of :bank_code, minimum: 3, maximum:3 , allow_blank: true
  validates_presence_of :bank_account, if: :bank_code?

  accepts_nested_attributes_for :picture

  def validates
    errors = []
    [ 'name', 'address' ].each do |attr|
      errors << self.class.i18n_simple_form_label(attr) if self.send(attr).blank?
    end

    { errors: errors, message: "請完成#{errors.join(' ')}的資料填寫" }
  end
end
