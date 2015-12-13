module Account::CustomersHelper
  def render_show_borrower_link(borrower)
    link_to render_icon('zoom-in'),
            borrower_path(borrower),
            class: 'btn btn-default', title: t('controller.action.show'), data: { toggle: 'tooltip' }
  end

  def render_edit_customer_link(borrower)
    if borrower.is_customer?
      link_to render_icon('edit', class: 'text-success'),
              edit_account_customer_path(borrower),
              class: 'btn btn-default', title: t('controller.action.edit'), data: { toggle: 'tooltip' }
    end
  end

  def render_operate_customer_links(customer)
    links = raw [
      render_show_borrower_link(customer),
      render_edit_customer_link(customer)
    ].join
    content_tag :div, links, class: 'btn-group'
  end

  def borrower_path borrower
    borrower.is_customer? ? account_customer_path(borrower) : user_path(borrower)
  end
end
