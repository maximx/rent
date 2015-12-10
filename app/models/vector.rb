class Vector < ActiveRecord::Base
  validates_presence_of :user_id, :subcategory_id, :tag_id
  validates_uniqueness_of :tag_id, scope: [ :user_id, :subcategory_id ]

  belongs_to :user
  belongs_to :subcategory
  belongs_to :tag
  accepts_nested_attributes_for :tag

  has_many :selections, dependent: :destroy
  has_many :selections_tags, through: :selections, source: :tag

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
