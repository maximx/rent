class Order < ActiveRecord::Base
  include CurrencyPrice
  include ScopeOverlaps

  belongs_to :borrower, polymorphic: true
  has_many :records

  scope :recent, -> { order(:created_at).reverse_order }

  def as_json(options={})
    {
      id: id,
      title: I18n.t('helpers.orders.json.title',
                    name: borrower.logo_name,
                    id: id,
                    price: currency_price),
      start: started_at,
      end: ended_at,
      url: Rails.application.routes.url_helpers.account_order_path(id)
    }
  end
end
