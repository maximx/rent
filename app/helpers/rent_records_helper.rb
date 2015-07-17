module RentRecordsHelper

  def render_edit_rent_record_link(rent_record)
    if rent_record.editable_by?(current_user)
      link_to(render_icon("edit", class: "text-success"),
              edit_item_rent_record_path(rent_record.item, rent_record),
              class: "btn btn-default", title: "修改", data: { toggle: "tooltip" })
    end
  end

  def render_renting_rent_record_link(rent_record)
    if rent_record.can_rent_by?(current_user)
      link_to(render_icon("ok", class: "text-primary"),
              renting_item_rent_record_path(rent_record.item, rent_record),
              method: :put,
              class: "btn btn-default", title: "確認出租",
              data: { toggle: "tooltip", confirm: "確認已交付出租物嗎？" })
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
      link_to(render_icon("remove", class: "text-danger").html_safe,
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
      link_to(render_icon("zoom-in", class: "text-info"), item_rent_record_path(rent_record.item, rent_record),
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
    [
      render_withdrawing_rent_record_link(rent_record),
      render_renting_rent_record_link(rent_record),
      render_returning_rent_record_link(rent_record),
      render_edit_rent_record_link(rent_record),
      render_ask_for_review_rent_record_link(rent_record),
      render_review_rent_record_link(rent_record),
      render_show_rent_record_link(rent_record)
    ].join(" ").html_safe
  end

  def render_datetime_period(obj, type = :db)
    "#{render_datetime(obj.started_at, type)} ~ #{render_datetime(obj.ended_at, type)}"
  end

  def render_datetime(datetime, type = :db)
    datetime.to_s(type)
  end

end
