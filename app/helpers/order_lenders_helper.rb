module OrderLendersHelper
  def render_download_order_lender_link(order_lender)
    if can?(:show, order_lender) and !order_lender.withdrawed?
      link_to render_icon('download-alt', class: 'text-danger'),
              order_order_lender_path(order_lender.order, order_lender, format: 'pdf'),
              target: '_blank',
              class: 'btn btn-default',
              data: { toggle: 'tooltip' },
              title: t('controller.order_lenders.action.download')
    end
  end
end
