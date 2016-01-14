module Lender::ItemsHelper
  def account_manage_navbar_list
    render_link_li class: 'nav navbar-nav' do |li|
      li << [render_icon_with_text('th-large', t('controller.name.lender')),
              '/lender',
              redirect_to: lender_orders_path, parent: true]
      li << [render_icon_with_text('record', t('controller.name.borrower')),
              '/borrower',
              redirect_to: borrower_orders_path, parent: true]

      if can? :read, Customer
        li << [render_icon_with_text('user', t('controller.name.account/customers')),
                account_customers_path, parent: true]
      end
      if can? :create, Vector
        li << [render_icon_with_text('paperclip', t('controller.name.account/categories')),
                account_categories_path, parent: true]
      end
    end
  end

  def render_lender_tablist
    render_link_li class: 'nav nav-tabs', role: 'tablist' do |li|
      li << [render_icon_with_text('list', t('controller.lender/orders.action.index')),
             lender_orders_path,
             parent: true, exclusion: calendar_lender_orders_path]

      li << [render_icon_with_text('calendar', t('controller.action.calendar')), calendar_lender_orders_path]

      li << [render_icon_with_text('list-alt', t('controller.lender/items.action.index')),
             lender_items_path,
             parent: true, exclusion: importer_lender_items_path]

      if can? :importer, Item
        li << [render_icon_with_text('import', t('controller.lender/items.action.importer')), importer_lender_items_path]
      end
    end
  end

  def render_lender_item_link(item)
    link_to render_icon('list-alt', class: 'text-primary'),
            lender_item_path(item),
            class: 'btn btn-default rent-records-list',
            title: t('controller.lender/items.action.show'),
            data: { toggle: 'tooltip' }
  end

  def render_operate_item_links(item)
    links = raw [
      render_new_item_record_path(item),
      render_lender_item_link(item),
      render_edit_item_link(item),
      render_open_item_link(item),
      render_close_item_link(item),
      render_destroy_item_link(item)
    ].join

    content_tag :div, links, class: 'btn-group'
  end

  def render_renting_checkbox(count)
    if count == 1
      render_icon("ok")
    else
      render_icon("unchecked")
    end
  end

  def account_manage_controller?
    account_manage_list = [
      'lender/items',
      'lender/records',
      'lender/calendars',
      'lender/orders',
      'borrower/orders',
      'account/customers',
      'account/shopping_carts',
      'account/items',
      'account/categories',
      'account/subcategories',
      'account/vectors',
      'account/selections'
    ]
    account_manage_list.include?(controller_path) and action_name != 'wish'
  end
end
