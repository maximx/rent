module Lender::OrdersHelper
  def render_show_order_link(order, options={})
    path = (current_user == order.borrower) ? borrower_order_path(order) : lender_order_path(order)
    icon = options.has_key?(:icon) ? options[:icon] : 'zoom-in'
    link_to render_icon(icon),
            path,
            class: 'btn btn-default', title: t('controller.action.show'),
            data: {toggle: 'tooltip'}
  end
end
