class Picture < ActiveRecord::Base
  attr_accessor :file_cached

  validates_presence_of :public_id, :file_cached
  belongs_to :imageable, polymorphic: true
  before_destroy :delete_cloudinary

  def only_one?
    imageable.pictures.size == 1
  end

  private

    def delete_cloudinary
      unless self.public_id == Rent::DEFAULT_AVATAR
        Cloudinary::Uploader.destroy(self.public_id)
      end
    end
end
