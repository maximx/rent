module Account::RecordsHelper
  def render_new_item_record_path item
    link_to render_icon('plus'),
            new_account_item_record_path(item),
            class: 'btn btn-default', title: t('controller.account/records.action.new'), data: { toggle: 'tooltip' }
  end

  def render_new_records_breadcrumbs item
    unless account_manage_controller?
      breadcrumb :new_record, item
    else
      breadcrumb :new_account_item_record, item
    end
  end

  def render_account_records_index_calendar
    render_link_li class: 'nav nav-tabs', role: 'tablist' do |li|
      li << [ render_icon_with_text('list-alt', t('controller.account/records.action.index')), account_records_path ]
      li << [ render_icon_with_text('calendar', t('controller.action.calendar')), calendar_account_records_path ]
    end
  end
end
