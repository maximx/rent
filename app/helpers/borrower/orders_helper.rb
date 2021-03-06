module Borrower::OrdersHelper
  def render_borrower_tablist
    render_link_li class: 'nav nav-tabs', role: 'tablist' do |li|
      li << [render_icon_with_text('th-list', t('controller.borrower/orders.action.index')),
             borrower_orders_path,
             parent: true, exclusion: calendar_borrower_orders_path]
      li << [render_icon_with_text('calendar', t('controller.action.calendar')), calendar_borrower_orders_path]
    end
  end
end
