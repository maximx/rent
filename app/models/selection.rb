class Selection < ActiveRecord::Base
  validates_presence_of :vector_id, :tag_id, :user_id
  validates_uniqueness_of :tag_id, scope: :vector_id

  belongs_to :user
  belongs_to :vector
  belongs_to :tag
  accepts_nested_attributes_for :tag

  has_many :items_selections, dependent: :destroy
  has_many :items, through: :items_selections

  before_validation :set_tag_id

  def name
    tag.name
  end

  private
    def set_tag_id
      if exist_tag = Tag.find_by_name(tag.name)
        self.tag_id = exist_tag.id
      else
        tag.save!
        self.tag_id = tag.id
      end
    end
end
