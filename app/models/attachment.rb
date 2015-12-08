class Attachment < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true

  mount_uploader :file, AttachmentUploader
  mount_uploader :image, ImageUploader

  before_save :set_attachment_attributes
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
      ( attachable.is_a? RecordStateLog and attachable.borrower == user ) or
      ( attachable.is_a? User and attachable == user ) or
      ( attachable.is_a? Item and attachable.lender == user and attachable.pictures.size > 1 )
    )
  end

  private
    def set_attachment_attributes
      if file.present? and file_changed?
        self.original_filename = file.file.original_filename
        self.content_type = file.file.content_type
        self.file_size = file.file.size
      end

      if image.present? and image_changed?
        self.original_filename = image.file.original_filename
        self.content_type = image.file.content_type
        self.file_size = image.file.size
      end
    end

    def recreate_image_versions!
      image.recreate_versions! if image.present?
    end
end
