class RecordStateLog < ActiveRecord::Base
  validates_presence_of :aasm_state, :borrower, :record_id
  validates :info, presence: true, length: { is: 5 }, format: { with: /\d/ }, if: :remitted?

  belongs_to :record
  belongs_to :borrower, polymorphic: true

  has_many :attachments, as: :attachable, dependent: :destroy

  def attachment
    attachments.first
  end

  def remitted?
    aasm_state == 'remitted'
  end

  def editable_by?(user)
    self.user == user
  end
end
