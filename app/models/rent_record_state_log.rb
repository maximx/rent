class RentRecordStateLog < ActiveRecord::Base
  validates_presence_of :aasm_state, :user_id, :rent_record_id

  belongs_to :rent_record
  belongs_to :user

  has_many :attachments, class_name: 'Picture', as: :imageable
  accepts_nested_attributes_for :attachments
end
