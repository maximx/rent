module Lender::RecordsHelper
  def render_new_item_record_path item
    link_to render_icon('plus'),
            new_lender_item_record_path(item),
            class: 'btn btn-default', title: t('controller.lender/records.action.new'), data: { toggle: 'tooltip' }
  end

  def render_records_currency_total_price(records)
    total_price = 0
    records.map {|record| total_price += record.total_price unless record.withdrawed?}
    total_price = total_price.to_i if total_price.to_i == total_price
    "$#{total_price}"
  end
end
