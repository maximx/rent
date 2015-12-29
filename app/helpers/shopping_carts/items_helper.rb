module ShoppingCarts::ItemsHelper
  def render_add_shopping_carts_item_link(item)
    link_to render_icon('plus', class: 'text-danger'),
            add_shopping_carts_item_path(item),
            class: 'btn btn-default', method: :post, remote: true,
            title: t('controller.items.action.add'), data: {toggle: 'tooltip'}
  end

  def render_remove_shopping_carts_item_link(item)
    link_to t('controller.action.destroy'),
            remove_shopping_carts_item_path(item),
            class: 'btn btn-danger btn-sm', method: :delete
  end
end
