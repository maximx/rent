class Customer < ActiveRecord::Base
  extend I18nMessage

  belongs_to :user
  has_many :rent_records, as: :borrower

  has_one :profile, as: :user
  accepts_nested_attributes_for :profile

  self.per_page = 15

  def account
    profile.name
  end
end
