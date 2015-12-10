class Vector < ActiveRecord::Base
  validates_presence_of :user_id, :subcategory_id

  belongs_to :user
  belongs_to :subcategory
  belongs_to :tag, autosave: true
  accepts_nested_attributes_for :tag

  has_many :selections
  has_many :selections_tags, through: :selections, source: :tag

  def name
    tag.name
  end

  private
    def autosave_associated_records_for_tag
      if new_tag = Tag.find_by_name(tag.name)
        self.tag = new_tag
      else
        tag.save!
        self.tag = tag
      end
    end
end
