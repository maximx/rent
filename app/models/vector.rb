class Vector < ActiveRecord::Base
  validates_presence_of :user_id, :subcategory_id, :tag_id
  validates_uniqueness_of :user_id, :subcategory_id, :tag_id => :friend_id

  belongs_to :user
  belongs_to :subcategory
  belongs_to :tag, autosave: true
  accepts_nested_attributes_for :tag

  private
    def autosave_associated_records_for_tag
      if new_tag = Tag.find_by_name(tag.name)
        self.tag = new_tag
      else
        self.tag.save!
      end
    end
end
