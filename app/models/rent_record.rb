class RentRecord < ActiveRecord::Base
  belongs_to :borrower, class_name: "User", foreign_key: "user_id"
  belongs_to :item

  def as_json(options={})
    {
      id: id,
      title: "#{name} - #{borrower.email}",
      start: started_at,
      end: ended_at,
      url: Rails.application.routes.url_helpers.item_rent_record_path(item, id)
    }
  end
end
