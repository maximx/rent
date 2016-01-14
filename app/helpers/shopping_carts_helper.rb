module ShoppingCartsHelper
  def render_shopping_cart_link
    icon = render_icon('shopping-cart',
                       title: t('controller.name.shopping_carts'),
                       data: {toggle: 'tooltip', placement: 'bottom'})
    link_to(icon, shopping_carts_path, class: 'icon-navbar')
  end

  def render_shopping_cart_form_url(customer = nil)
    if customer
      account_customer_shopping_carts_path(customer)
    else
      shopping_carts_path
    end
  end
end
