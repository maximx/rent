class Selection < ActiveRecord::Base
  belongs_to :vector
  belongs_to :tag, autosave: true
  accepts_nested_attributes_for :tag

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
