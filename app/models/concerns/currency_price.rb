module CurrencyPrice
  extend ActiveSupport::Concern

  ['price', 'deposit', 'total_price', 'deliver_fee', 'total_net_price'].each do |attr|
    define_method("currency_#{attr}") do
      value = send(attr)
      (value == value.to_i) ?  "$#{value.to_i}" : "$#{value}"
    end

    # for model records
    define_method("currency_item_#{attr}") do
      value = send("item_#{attr}")
      (value == value.to_i) ?  "$#{value.to_i}" : "$#{value}"
    end
  end
end
