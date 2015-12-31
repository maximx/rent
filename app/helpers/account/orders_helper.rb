module Account::OrdersHelper
  def render_account_orders_tablist
    render_link_li class: 'nav nav-tabs', role: 'tablist' do |li|
      li << [render_icon_with_text('list-alt', t('controller.account/records.action.index')), account_records_path]
      li << [render_icon_with_text('th-list', t('controller.account/orders.action.index')), account_orders_path]
      li << [render_icon_with_text('calendar', t('controller.action.calendar')), calendar_account_records_path]
    end
  end
end
