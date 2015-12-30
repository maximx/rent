class Order < ActiveRecord::Base
  include CurrencyPrice

  belongs_to :borrower, polymorphic: true
  has_many :records

  scope :recent, -> { order(:created_at).reverse_order }
  scope :overlaps, ->(started_at, ended_at) do
    where("(TIMESTAMPDIFF(SECOND, orders.started_at, ?) * TIMESTAMPDIFF(SECOND, ?, orders.ended_at)) >= 0", ended_at, started_at)
  end

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
