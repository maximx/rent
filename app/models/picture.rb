class Picture < ActiveRecord::Base
  attr_accessor :file_cached

  validates_presence_of :public_id, :file_cached

  belongs_to :imageable, polymorphic: true

  before_save :upload_and_set_public_id, if: Proc.new { |p| p.file_cached != 'faker' }
  before_destroy :delete_cloudinary

  def filename
    [public_id, format].join('.')
  end

  def viewable_by?(user)
    user and (
      ( imageable.is_a? RecordStateLog and imageable.record.viewable_by?(user) ) or
      ( imageable.is_a? Item ) or
      ( imageable.is_a? User )
    )
  end

  def editable_by?(user)
    user and (
      ( imageable.is_a? RentRecordStateLog and imageable.editable_by?(user) ) or
      ( imageable.is_a? User and imageable == user ) or
      ( imageable.is_a? Item and imageable.editable_by?(user) )
    )
  end

  def delete_cloudinary
    unless self.public_id == Rent::DEFAULT_AVATAR
      Cloudinary::Uploader.destroy(self.public_id)
    end
  end

  private

    def upload_and_set_public_id
      unless self.new_record?
        self.class.find(self.id).delete_cloudinary
      end

      info = Cloudinary::Uploader.upload(self.file_cached, use_filename: true)
      self.public_id = info['public_id']
      self.format = info['format']
    end
end
