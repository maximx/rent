module RentRecordsHelper

  def render_edit_rent_record_link(rent_record)
    if rent_record.editable_by?(current_user)
      link_to("修改",
              edit_item_rent_record_path(rent_record.item, rent_record),
              class: "btn btn-default")
    end
  end

  def render_renting_rent_record_link(rent_record)
    if rent_record.can_rent_by?(current_user)
      link_to("確認出租",
              renting_item_rent_record_path(rent_record.item, rent_record),
              method: :put,
              class: "btn btn-primary",
              data: { confirm: "確認已交付出租物嗎？" })
    end
  end

  def render_returning_rent_record_link(rent_record)
    if rent_record.can_return_by?(current_user)
      link_to("確認歸還",
              returning_item_rent_record_path(rent_record.item, rent_record),
              method: :put,
              class: "btn btn-danger",
              data: { confirm: "確認已歸還出租物嗎？" })
    end
  end

  def render_withdrawing_rent_record_link(rent_record)
    if rent_record.can_withdraw_by?(current_user)
      link_to("取消預訂",
              withdrawing_item_rent_record_path(rent_record.item, rent_record),
              method: :delete,
              class: "btn btn-danger",
              data: { confirm: "確定要取消預約#{rent_record.item.name}嗎？"})
    end
  end

  def render_review_rent_record_link(rent_record)
    if rent_record.can_review_by?(current_user)
      link_to("評價",
              review_item_rent_record_path(rent_record.item, rent_record),
              class: "btn btn-info")
    end
  end

  def render_show_rent_record_link(rent_record)
    if rent_record.viewable_by?(current_user)
      link_to("查閱", item_rent_record_path(rent_record.item, rent_record), class: "btn btn-default")
    end
  end

  def render_ask_for_review_rent_record_link(rent_record)
    if rent_record.can_ask_review_by?(current_user)
      link_to("邀請評價",
              ask_for_review_item_rent_record_path(rent_record.item, rent_record),
              method: :post,
              class: "btn btn-success",
              data: { confirm: "將寄出信件邀請對方評價，確認要繼續嗎？"})
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

  def render_datetime_period(obj)
    "#{render_datetime(obj.started_at)} ~ #{render_datetime(obj.ended_at)}"
  end

  def render_datetime(datetime)
    datetime.to_s(:db)
  end

end
