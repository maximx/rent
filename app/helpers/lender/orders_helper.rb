module Lender::OrdersHelper
  def render_show_order_link(order, role)
    send("render_show_#{role}_order_link",order)
  end

  def render_show_lender_order_link(order)
    render_show_common_order_link lender_order_path(order)
  end

  def render_show_common_order_link(path)
    link_to render_icon('zoom-in'),
            path,
            class: 'btn btn-default', title: t('controller.action.show'),
            data: {toggle: 'tooltip'}
  end
end
