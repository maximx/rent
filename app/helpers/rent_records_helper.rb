module RentRecordsHelper

  def render_item_rent_record_link_by_state(item, rent_record)
    if rent_record.editable_by?(current_user)
      render_edit_item_rent_record_link(item, rent_record)
    elsif rent_record.can_rent_by?(current_user)
      link_to("確認出租",
              renting_item_rent_record_path(item, rent_record),
              method: :put,
              data: { confirm: "確認已交付出租物嗎？" })
    elsif rent_record.can_return_by?(current_user)
      link_to("確認歸還",
              returning_item_rent_record_path(item, rent_record),
              method: :put,
              data: { confirm: "確認已歸還出租物嗎？" })
    elsif rent_record.can_review_by?(current_user)
      link_to("評價", review_item_rent_record_path(item, rent_record))
    end
  end

  def render_edit_item_rent_record_link(item, rent_record)
    if rent_record.editable_by?(current_user)
      link_to("修改", edit_item_rent_record_path(item, rent_record), class: "btn btn-default")
    end
  end
end
