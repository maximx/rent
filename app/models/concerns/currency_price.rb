module CurrencyPrice
  ['price', 'deposit', 'total_price', 'deliver_fee'].each do |attr|
    define_method("currency_#{attr}") { "$#{send(attr)}" }
    define_method("currency_item_#{attr}") { "$#{send("item_#{attr}")}" } # for model rent_records
  end
end
