class RentRecordStateLog < ActiveRecord::Base
  validates_presence_of :aasm_state, :user_id, :rent_record_id
  validates :info, presence: true, length: { is: 5 }, format: { with: /\d/ }, if: :remitted?

  belongs_to :rent_record
  belongs_to :user

  has_many :attachments, class_name: 'Picture', as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :attachments

  def attachment
    attachments.first
  end

  def remitted?
    aasm_state == 'remitted'
  end
end
