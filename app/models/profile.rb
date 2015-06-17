class Profile < ActiveRecord::Base
  validates_presence_of :name

  belongs_to :user
  has_one :picture, as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :picture

  after_create :create_picture

  private

    def create_picture
      default_avatar = "default-avatar"
      picture = build_picture
      picture.public_id = default_avatar
      picture.save
    end
end
