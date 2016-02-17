module Borrower::OrderLendersHelper
  def render_remitting_order_lender_link(order_lender)
    if can? :remitting, order_lender
      link_to render_icon('usd', class: 'text-success'),
              remitting_borrower_order_order_lender_path(order_lender.order, order_lender),
              method: :put,
              class: 'btn btn-default',
              title: t('controller.borrower/order_lenders.action.remitting'),
              data: { toggle: 'tooltip', label: info_label[:remitted], required: 'required' }
    end
  end

  def render_withdrawing_order_lender_link(order_lender)
    if can? :withdrawing, order_lender
      link_to render_icon('remove', class: 'text-danger'),
              withdrawing_borrower_order_order_lender_path(order_lender.order, order_lender),
              method: :delete,
              class: 'btn btn-default',
              title: t('controller.borrower/order_lenders.action.withdrawing'),
              data: { toggle: 'tooltip', confirm: t('helpers.borrower/order_lenders.withdrawing_confirm') }
    end
  end
end
