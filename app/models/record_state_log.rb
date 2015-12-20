class RecordStateLog < ActiveRecord::Base
  validates_presence_of :aasm_state, :borrower, :record_id
  validates :info, presence: true, length: { is: 5 }, format: { with: /\d/ }, if: :remitted?

  belongs_to :record
  belongs_to :borrower, polymorphic: true

  has_many :attachments, as: :attachable, dependent: :destroy

  after_save :send_remitted_message

  def attachment
    attachments.first
  end

  def remitted?
    aasm_state.to_s == 'remitted'
  end

  def renting?
    aasm_state.to_s == 'renting'
  end

  private
    def send_remitted_message
      RecordStateLogMailer.send_remitted_message(self).deliver if remitted?
    end
end
