module RecordsHelper
  def render_download_record_link(record)
    if can? :show, record
      link_to render_icon('download-alt', class: 'text-danger'),
              item_record_path(record.item, record, format: 'pdf'),
              target: '_blank', class: 'btn btn-default', data: { toggle: 'tooltip' },
              title: t('controller.records.action.download')
    end
  end

  def render_remitting_record_link(record)
    if can? :remitting, record
      link_to render_icon('usd', class: 'text-success'),
              remitting_item_record_path(record.item, record),
              method: :put, class: 'btn btn-default record_form_modal', title: t('controller.records.action.remitting'),
              data: { toggle: 'tooltip', label: info_label[:remitted], required: 'required' }
    end
  end

  def render_delivering_record_link(record)
    if can? :delivering, record
      link_to render_icon('globe', class: 'text-primary'),
              delivering_item_record_path(record.item, record),
              method: :put, class: 'btn btn-default record_form_modal', title: t('controller.records.action.delivering'),
              data: { toggle: 'tooltip', label: info_label[:delivering] }
    end
  end

  def render_renting_record_link(record)
    if can? :renting, record
      link_to render_icon('ok', class: 'text-primary'),
              renting_item_record_path(record.item, record),
              method: :put, class: 'btn btn-default record_form_modal', title: t('controller.records.action.renting'),
              data: { toggle: 'tooltip', type: 'file', label: info_label[:renting] }
    end
  end

  def render_returning_record_link(record)
    if can? :returning, record
      link_to render_icon('home', class: 'text-warning'),
              returning_item_record_path(record.item, record),
              method: :put,
              class: 'btn btn-default', title: t('controller.records.action.returning'),
              data: { toggle: 'tooltip', confirm: t('helpers.records.returning_confirm') }
    end
  end

  def render_withdrawing_record_link(record)
    if can? :withdrawing, record
      link_to render_icon('remove', class: 'text-danger'),
              withdrawing_item_record_path(record.item, record),
              method: :delete, class: 'btn btn-default', title: t('controller.records.action.withdrawing'),
              data: { toggle: 'tooltip', confirm: t('helpers.records.withdrawing_confirm', name: record.item.name) }
    end
  end

  def render_show_record_link(record)
    if can?(:show, record) and !current_page?(item_record_path(record.item, record))
      link_to render_icon('zoom-in'),
              item_record_path(record.item, record),
              class: 'btn btn-default', title: t('controller.records.action.show'), data: { toggle: 'tooltip' }
    end
  end

  def render_review_record_link(record)
    if can? :review, record
      link_to render_icon('thumbs-up', class: 'text-info'),
              review_item_record_path(record.item, record),
              class: 'btn btn-default', data: { toggle: 'tooltip' },
              title: t('controller.records.action.review')
    end
  end

  def render_ask_for_review_record_link(record)
    if can? :ask_for_review, record
      link_to render_icon('send', class: 'text-success'),
              ask_for_review_item_record_path(record.item, record),
              method: :post, class: 'btn btn-default',
              title: t('controller.records.action.ask_for_review'),
              data: { toggle: 'tooltip', confirm: t('helpers.records.ask_for_review_confirm') }
    end
  end

  def render_operate_record_links(record)
    links = raw [
      render_withdrawing_record_link(record),
      render_remitting_record_link(record),
      render_delivering_record_link(record),
      render_renting_record_link(record),
      render_returning_record_link(record),
      render_ask_for_review_record_link(record),
      render_review_record_link(record),
      render_show_record_link(record),
      render_download_record_link(record)
    ].join

    content_tag :div, links, class: 'btn-group record_operates'
  end

  def info_label
    {
      remitted: '帳號末五碼',
      delivering: '寄送編號',
      renting: '承租契約'
    }
  end

  def render_state_log_title(log)
    titles = [ log.borrower.account ]
    titles << "#{info_label[log.aasm_state.to_sym]} #{log.info}" unless log.info.blank?
    titles << render_datetime(log.created_at, :tw)
    titles.join(tag(:br))
  end

  def render_records_form_options(item)
    options = {}
    options[:wrapper] = 'default' unless full_form?
    options[:url] = dashboard_item_records_path(item) if dashboard_related_controller?
    options
  end

  def records_form_wrapper
    full_form? ? 'bootstrap_horizontal' : 'default'
  end

  def render_records_input_wrapper(html, options = { class: 'col-sm-12' })
    full_form? ? html : content_tag(:div, html, options)
  end

  def render_datetime_period(obj, type = :db)
    "#{render_datetime(obj.started_at, type)} ~ #{render_datetime(obj.ended_at, type)}"
  end

  def render_datetime(datetime, type = :db)
    datetime.to_s(type)
  end

  def full_form?
    !items_controller?
  end

  def records_controller?
    params[:controller] == 'records'
  end
end
