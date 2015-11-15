module Dashboard::CustomersHelper
  def render_show_customer_link(customer)
    link = customer.is_a?(Customer) ? dashboard_customer_path(customer) : user_path(customer)

    link_to render_icon('zoom-in'),
            link,
            class: 'btn btn-default', title: '查閱', data: { toggle: 'tooltip' }
  end

  def render_edit_customer_link(customer)
    if customer.is_a? Customer
      link_to render_icon('edit', class: 'text-success'),
              edit_dashboard_customer_path(customer),
              class: 'btn btn-default', title: '修改', data: { toggle: 'tooltip' }
    end
  end

  def render_operate_customer_links(customer)
    links = raw [
      render_show_customer_link(customer),
      render_edit_customer_link(customer)
    ].join
    content_tag :div, links, class: 'btn-group'
  end
end
