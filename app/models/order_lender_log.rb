class OrderLenderLog < ActiveRecord::Base
  validates_presence_of :order_lender_id, :aasm_state, :user
  validates :info, presence: true, length: { is: 5 }, format: { with: /\d/ }, if: :remitted?

  belongs_to :order_lender
  belongs_to :user, polymorphic: true

  has_many :attachments, as: :attachable, dependent: :destroy

  def remitted?
    aasm_state.to_s == 'remitted'
  end

  def renting?
    aasm_state.to_s == 'renting'
  end
end
