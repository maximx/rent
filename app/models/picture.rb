class Picture < ActiveRecord::Base
  validates_presence_of :public_id
  belongs_to :imageable, polymorphic: true
  before_destroy :delete_cloudinary

  private

    def delete_cloudinary
      Cloudinary::Uploader.destroy(self.public_id)
    end
end
