module RentRecordsHelper
  def render_download_rent_record_link(rent_record)
    if rent_record.viewable_by?(current_user)
      link_to(render_icon('download-alt', class: 'text-danger'),
              item_rent_record_path(rent_record.item, rent_record, format: 'pdf'),
              target: '_blank', title: '下載契約',
              class: 'btn btn-default', data: { toggle: 'tooltip' })
    end
  end

  def render_remitting_rent_record_link(rent_record)
    if rent_record.can_remit_by?(current_user)
      link_to render_icon('usd', class: 'text-success'),
              remitting_item_rent_record_path(rent_record.item, rent_record),
              method: :put, class: 'btn btn-default rent_record_form_modal', title: '已匯款',
              data: { toggle: 'tooltip', label: info_label[:remitted], required: 'required' }
    end
  end

  def render_delivering_rent_record_link(rent_record)
    if rent_record.can_delivery_by?(current_user)
      link_to render_icon('globe', class: 'text-primary'),
              delivering_item_rent_record_path(rent_record.item, rent_record),
              method: :put, class: 'btn btn-default rent_record_form_modal', title: '已寄送',
              data: { toggle: 'tooltip', label: info_label[:delivering] }
    end
  end

  def render_renting_rent_record_link(rent_record)
    if rent_record.can_rent_by?(current_user)
      link_to render_icon('ok', class: 'text-primary'),
              renting_item_rent_record_path(rent_record.item, rent_record),
              method: :put, class: 'btn btn-default rent_record_form_modal', title: '確認出租',
              data: { toggle: 'tooltip', type: 'file', label: info_label[:renting] }
    end
  end

  def render_returning_rent_record_link(rent_record)
    if rent_record.can_return_by?(current_user)
      link_to(render_icon("home", class: "text-warning"),
              returning_item_rent_record_path(rent_record.item, rent_record),
              method: :put,
              class: "btn btn-default", title: "確認歸還",
              data: { toggle: "tooltip", confirm: "確認已歸還出租物嗎？" })
    end
  end

  def render_withdrawing_rent_record_link(rent_record)
    if rent_record.can_withdraw_by?(current_user)
      link_to(render_icon("remove", class: "text-danger"),
              withdrawing_item_rent_record_path(rent_record.item, rent_record),
              method: :delete,
              class: "btn btn-default", title: "取消預訂",
              data: { toggle: "tooltip", confirm: "確定要取消預約#{rent_record.item.name}嗎？"})
    end
  end

  def render_review_rent_record_link(rent_record)
    if rent_record.can_review_by?(current_user)
      link_to(render_icon("thumbs-up", class: "text-info"),
              review_item_rent_record_path(rent_record.item, rent_record),
              class: "btn btn-default", title: "評價", data: { toggle: "tooltip" })
    end
  end

  def render_show_rent_record_link(rent_record)
    if rent_record.viewable_by?(current_user) && !current_page?(item_rent_record_path(rent_record.item, rent_record))
      link_to(render_icon('zoom-in'), item_rent_record_path(rent_record.item, rent_record),
              class: "btn btn-default", title: "查閱", data: { toggle: "tooltip" })
    end
  end

  def render_ask_for_review_rent_record_link(rent_record)
    if rent_record.can_ask_review_by?(current_user)
      link_to(render_icon("send", class: "text-success"),
              ask_for_review_item_rent_record_path(rent_record.item, rent_record),
              method: :post,
              class: "btn btn-default", title: "邀請評價",
              data: { toggle: "tooltip", confirm: "將寄出信件邀請對方評價，確認要繼續嗎？"})
    end
  end

  def render_operate_rent_record_links(rent_record)
    links = raw [
      render_withdrawing_rent_record_link(rent_record),
      render_remitting_rent_record_link(rent_record),
      render_delivering_rent_record_link(rent_record),
      render_renting_rent_record_link(rent_record),
      render_returning_rent_record_link(rent_record),
      render_ask_for_review_rent_record_link(rent_record),
      render_review_rent_record_link(rent_record),
      render_show_rent_record_link(rent_record),
      render_download_rent_record_link(rent_record)
    ].join

    content_tag :div, links, class: 'btn-group rent_record_operates'
  end

  def info_label
    {
      remitted: '帳號末五碼',
      delivering: '寄送編號',
      renting: '承租契約'
    }
  end

  def render_state_log_title(log)
    titles = [ log.user.account ]
    titles << "#{info_label[log.aasm_state.to_sym]} #{log.info}" unless log.info.blank?
    titles << render_datetime(log.created_at, :tw)
    titles.join(tag(:br))
  end

  def render_rent_records_form_wrapper
    rent_records_controller? ? 'bootstrap_horizontal' : 'default'
  end

  def render_rent_records_input_wrapper(html, options = { class: 'col-sm-12' })
    rent_records_controller? ? html : content_tag(:div, html, options)
  end

  def render_datetime_period(obj, type = :db)
    "#{render_datetime(obj.started_at, type)} ~ #{render_datetime(obj.ended_at, type)}"
  end

  def render_datetime(datetime, type = :db)
    datetime.to_s(type)
  end

  def rent_records_controller?
    params[:controller] == 'rent_records'
  end
end
