class RentRecord < ActiveRecord::Base
  include AASM

  belongs_to :borrower, class_name: "User", foreign_key: "user_id"
  belongs_to :item
  has_one :review

  aasm no_direct_assignment: true do
    state :booking, initial: true
    state :renting
    state :withdrawed
    state :returned

    event :rent do
      transitions from: :booking, to: :renting
    end

    event :withdraw do
      transitions from: :booking, to: :withdrawed
    end

    event :return do
      transitions from: :renting, to: :returned
    end
  end

  def as_json(options={})
    {
      id: id,
      title: "#{name} - #{borrower.email}",
      start: started_at,
      end: ended_at,
      url: Rails.application.routes.url_helpers.item_rent_record_path(item, id)
    }
  end

  def viewable_by?(user)
    user && [item.lender, borrower].include?(user)
  end
end
