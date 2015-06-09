module RentRecordsHelper

  def render_edit_item_rent_record_link(rent_record)
    if rent_record.editable_by?(current_user)
      link_to("修改", edit_item_rent_record_path(rent_record.item, rent_record), class: "btn btn-default")
    end
  end

  def render_renting_item_rent_record_link(rent_record)
    if rent_record.can_rent_by?(current_user)
      link_to("確認出租",
              renting_item_rent_record_path(rent_record.item, rent_record),
              method: :put,
              class: "btn btn-primary",
              data: { confirm: "確認已交付出租物嗎？" })
    end
  end

  def render_returning_item_rent_record_link(rent_record)
    if rent_record.can_return_by?(current_user)
      link_to("確認歸還",
              returning_item_rent_record_path(rent_record.item, rent_record),
              method: :put,
              class: "btn btn-danger",
              data: { confirm: "確認已歸還出租物嗎？" })
    end
  end

  def render_review_item_rent_record_link(rent_record)
    if rent_record.can_review_by?(current_user)
      link_to("評價", review_item_rent_record_path(rent_record.item, rent_record), class: "btn btn-info")
    end
  end

  def render_show_item_rent_record_link(rent_record)
    if rent_record.viewable_by?(current_user)
      link_to("查閱", item_rent_record_path(rent_record.item, rent_record), class: "btn btn-warning")
    end
  end

end
