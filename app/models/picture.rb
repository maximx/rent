class Picture < ActiveRecord::Base
  validates_presence_of :public_id
  belongs_to :imageable, polymorphic: true
  before_destroy :delete_cloudinary

  def only_one?
    imageable.pictures.size == 1
  end

  private

    def delete_cloudinary
      unless self.public_id == DEFAULT_AVATAR
        Cloudinary::Uploader.destroy(self.public_id)
      end
    end
end
