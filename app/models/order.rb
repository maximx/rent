class Order < ActiveRecord::Base
  include CurrencyPrice
  include ScopeOverlaps

  belongs_to :borrower, polymorphic: true
  has_many :records
  has_many :lenders, ->{uniq}, through: :records

  scope :recent, -> { order(:created_at).reverse_order }

  def as_json(options={})
    {
      id: id,
      title: json_title,
      start: started_at,
      end: ended_at,
      url: json_url
    }
  end

  def json_title
    I18n.t('helpers.orders.json.title', name: borrower.logo_name, id: id, price: currency_price)
  end

  def json_url
    Rails.application.routes.url_helpers.account_order_path(id)
  end

  def records_of(lender)
    records.joins(:lender).where(items: {user_id: lender.id})
  end

  def borrower?(user)
    borrower == user
  end
end
