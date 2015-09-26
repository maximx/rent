class Picture < ActiveRecord::Base
  attr_accessor :file_cached

  validates_presence_of :public_id, :file_cached

  belongs_to :imageable, polymorphic: true

  before_save :upload_and_set_public_id, if: Proc.new { |p| p.file_cached != 'faker' }
  before_destroy :delete_cloudinary

  def only_one?
    imageable.pictures.size == 1
  end

  private

    def upload_and_set_public_id
      self.public_id = Cloudinary::Uploader.upload(self.file_cached, use_filename: true)["public_id"]
    end

    def delete_cloudinary
      unless self.public_id == Rent::DEFAULT_AVATAR
        Cloudinary::Uploader.destroy(self.public_id)
      end
    end
end
