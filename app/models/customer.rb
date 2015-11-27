class Customer < ActiveRecord::Base
  belongs_to :user
  has_many :records, as: :borrower

  has_one :profile, as: :user
  accepts_nested_attributes_for :profile

  def account
    profile.name
  end

  def self.search_types
    [
      [ I18n.t('simple_form.labels.customer.email'), 'email' ],
      [ I18n.t('simple_form.labels.profile.name'), 'name' ],
      [ I18n.t('simple_form.labels.profile.phone'), 'phone' ]
    ]
  end

  def is_customer?
    self.is_a? Customer
  end
end
