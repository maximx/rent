module Lender::RecordsHelper
  def render_new_item_record_path item
    link_to render_icon('plus'),
            new_lender_item_record_path(item),
            class: 'btn btn-default', title: t('controller.lender/records.action.new'), data: { toggle: 'tooltip' }
  end
end
