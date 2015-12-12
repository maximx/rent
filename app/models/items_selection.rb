class ItemsSelection < ActiveRecord::Base
  validates_presence_of :vector_id, :selection_id
  validates_uniqueness_of :vector_id, scope: :item_id

  belongs_to :item
  belongs_to :vector
  belongs_to :selection

  before_validation :set_vector_id

  private
    def set_vector_id
      new_selection = Selection.find selection_id
      self.vector_id = new_selection.vector_id
    end
end
