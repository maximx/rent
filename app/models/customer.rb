class Customer < ActiveRecord::Base
  extend I18nMessage

  belongs_to :user
  has_many :records, as: :borrower

  has_one :profile, as: :user
  accepts_nested_attributes_for :profile

  def account
    profile.name
  end

  def self.search_types
    [
      [i18n_simple_form_label('email'), 'email'],
      [Profile.i18n_simple_form_label('name'), 'name'],
      [Profile.i18n_simple_form_label('phone'), 'phone']
    ]
  end

  def is_customer?
    self.is_a? Customer
  end
end
