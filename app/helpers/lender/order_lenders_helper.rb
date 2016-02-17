module Lender::OrderLendersHelper
  def render_delivering_order_lender_link(order_lender)
    if can? :delivering, order_lender
      link_to render_icon('globe', class: 'text-primary'),
              delivering_lender_order_order_lender_path(order_lender.order, order_lender),
              method: :put,
              class: 'btn btn-default log_form_modal',
              title: t('controller.lender/order_lenders.action.delivering'),
              data: { toggle: 'tooltip', label: info_label[:delivering] }
    end
  end

  def render_renting_order_lender_link(order_lender)
    if can? :renting, order_lender
      link_to render_icon('ok', class: 'text-primary'),
              renting_lender_order_order_lender_path(order_lender.order, order_lender),
              method: :put,
              class: 'btn btn-default log_form_modal',
              title: t('controller.lender/order_lenders.action.renting'),
              data: { toggle: 'tooltip', type: 'file', label: info_label[:renting] }
    end
  end

  def render_returning_order_lender_link(order_lender)
    if can? :returning, order_lender
      link_to render_icon('home', class: 'text-warning'),
              returning_lender_order_order_lender_path(order_lender.order, order_lender),
              method: :put,
              class: 'btn btn-default',
              title: t('controller.lender/order_lenders.action.returning'),
              data: { toggle: 'tooltip', confirm: t('helpers.lender/order_lenders.returning_confirm') }
    end
  end

  def render_operate_order_lender_links(order_lender)
    links = raw [
      render_remitting_order_lender_link(order_lender),
      render_withdrawing_order_lender_link(order_lender),
      render_delivering_order_lender_link(order_lender),
      render_renting_order_lender_link(order_lender),
      render_returning_order_lender_link(order_lender)
    ].join
    content_tag :div, links, class: 'btn-group btn-group-sm order_lender_operates'
  end

  def info_label
    {
      remitted: '帳號末五碼',
      delivering: '寄送編號',
      renting: '承租契約'
    }
  end
end
