module Account::CustomersHelper
  def render_show_borrower_link(borrower)
    unless current_page?(account_customer_path(borrower))
      link_to render_icon('zoom-in'),
              borrower_path(borrower),
              class: 'btn btn-default', title: t('controller.action.show'), data: { toggle: 'tooltip' }
    end
  end

  def render_edit_customer_link(borrower)
    if borrower.is_customer?
      link_to render_icon('edit', class: 'text-success'),
              edit_account_customer_path(borrower),
              class: 'btn btn-default', title: t('controller.action.edit'), data: {toggle: 'tooltip'}
    end
  end

  def render_account_customer_items_path(borrower)
    if borrower.is_customer?
      link_to render_icon('list', class: 'text-info'),
              account_customer_items_path(borrower),
              class: 'btn btn-default', title: t('controller.account/items.action.index'), data: {toggle: 'tooltip'}
    end
  end

  def render_operate_customer_links(customer)
    links = raw [
      render_show_borrower_link(customer),
      render_edit_customer_link(customer),
      render_account_customer_items_path(customer)
    ].join
    content_tag :div, links, class: 'btn-group'
  end

  def borrower_path(borrower)
    borrower.is_customer? ? account_customer_path(borrower) : user_path(borrower)
  end
end
