module ShoppingCarts::ItemsHelper
  def render_add_shopping_carts_item_link(item, customer = nil)
    add_url = (customer) ?
      add_account_customer_item_path(customer, item) : add_shopping_carts_item_path(item)

    link_to render_icon('plus', class: 'text-danger'),
            add_url,
            class: 'btn btn-default', method: :post, remote: true,
            title: t('controller.items.action.add'), data: {toggle: 'tooltip'}
  end

  def render_remove_shopping_carts_item_link(item, customer = nil)
    remove_url = (customer) ?
      remove_account_customer_item_path(customer, item) : remove_shopping_carts_item_path(item)

    link_to t('controller.action.destroy'),
            remove_url,
            class: 'btn btn-danger btn-sm', method: :delete
  end
end
