class Attachment < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true
  mount_uploader :file, AttachmentUploader
  mount_uploader :image, ImageUploader

  after_save :recreate_image_versions!

  def viewable_by?(user)
    user and (
      ( attachable.is_a? RecordStateLog and attachable.record.viewable_by?(user) ) or
      ( attachable.is_a? Item ) or
      ( attachable.is_a? User )
    )
  end

  def editable_by?(user)
    user and (
      ( attachable.is_a? RecordStateLog and attachable.editable_by?(user) ) or
      ( attachable.is_a? User and attachable == user ) or
      ( attachable.is_a? Item and attachable.editable_by?(user) and attachable.pictures.size > 1 )
    )
  end

  private
    def recreate_image_versions!
      image.recreate_versions! if image.present?
    end
end
