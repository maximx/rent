class ItemsSelection < ActiveRecord::Base
  validates_presence_of :item_id, :vector_id, :selection_id
  validates_uniqueness_of :vector_id, scope: :item_id

  belongs_to :item
  belongs_to :vector
  belongs_to :selection

  before_validation :set_vector_id

  private
    def set_vector_id
      if self.new_record?
        self.vector_id = self.selection.vector.id
      end
    end
end
