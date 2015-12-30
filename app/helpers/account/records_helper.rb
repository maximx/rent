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
end
