module RecordsHelper
  def render_record_borrower_link(record)
    if can? :show, record
      link_to record.borrower.logo_name, borrower_path(record.borrower)
    else
      mask record.borrower.logo_name
    end
  end

  def render_download_record_link(record)
    if can?(:show, record) and !record.withdrawed?
      link_to render_icon('download-alt', class: 'text-danger'),
              item_record_path(record.item, record, format: 'pdf'),
              target: '_blank', class: 'btn btn-default', data: { toggle: 'tooltip' },
              title: t('controller.records.action.download')
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
    if can? :create, record.reviews.build
      link_to render_icon('thumbs-up', class: 'text-info'),
              new_item_record_review_path(record.item, record),
              class: 'btn btn-default', data: { toggle: 'tooltip' },
              title: t('controller.reviews.action.new')
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

  def render_operate_record_links(record, batch=false)
    links = raw [
      #render_ask_for_review_record_link(record),
      #render_review_record_link(record),
      render_show_record_link(record),
      render_download_record_link(record)
    ].join
    content_tag :div, links, class: 'btn-group record_operates'
  end

  def render_record_price_equation(record)
    return render_currency_money(record.item_price) if record.per_time?

    t("helpers.records.show.per_day_price",
       item_price: render_currency_money(record.item_price),
       rent_days: record.rent_days,
       free_days: record.free_days,
       price: render_currency_money(record.price)
     )
  end

  def render_record_total_price_equation(record)
    t("helpers.records.show.total_price_equation",
       price: render_currency_money(record.price),
       deliver_fee: render_currency_money(record.deliver_fee),
       deposit: render_currency_money(record.item_deposit),
       total_price: render_currency_money(record.total_price)
     )
  end

  def render_record_deliver_address(record)
    address_msg = record.deliver.address_needed? ? :deliver_address : :lender_address
    t("helpers.records.show.#{address_msg}", address: record.address)
  end

  def render_records_form_options(item)
    options = {}
    options[:wrapper] = 'default' unless full_form?
    options[:url] = lender_item_records_path(item) if account_manage_controller?
    options
  end

  def records_form_wrapper
    full_form? ? 'bootstrap_horizontal' : 'default'
  end

  def render_records_input_wrapper(html, options = { class: 'col-sm-12' })
    full_form? ? html : content_tag(:div, html, options)
  end

  def render_records_currency_total_price(records)
    total_price = 0
    records.map {|record| total_price += record.total_price unless record.withdrawed?}
    total_price = total_price.to_i if total_price.to_i == total_price
    render_currency_money total_price
  end

  def render_datetime_period(obj, type = :tw)
    "#{render_datetime(obj.started_at, type)} ~ #{render_datetime(obj.ended_at, type)}"
  end

  def render_datetime(datetime, type = :tw)
    datetime.to_s(type)
  end

  def full_form?
    !items_controller?
  end

  def records_controller?
    controller_path == 'records'
  end
end
