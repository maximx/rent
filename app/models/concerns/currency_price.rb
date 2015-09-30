module CurrencyPrice
  ['price', 'deposit', 'down_payment', 'total_price'].each do |attr|
    define_method("currency_#{attr}") { "$#{send(attr)}" }
    define_method("currency_item_#{attr}") { "$#{send("item_#{attr}")}" } # for model rent_records
  end
end
