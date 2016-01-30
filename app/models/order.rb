class Order < ActiveRecord::Base
  include DatetimeOverlaps

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
      url: json_url(options)
    }
  end

  def json_title
    I18n.t('helpers.orders.json.title', name: borrower.logo_name, id: id, price: currency_total_price)
  end

  def json_url(options={})
    Rails.application.routes.url_helpers.send("#{options[:role]}_order_path", id)
  end

  def records_of(lender)
    records.joins(:lender).where(items: {user_id: lender.id})
  end

  def total_price
    deposit + deliver_fee + price
  end
end
