class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :items
  has_many :questions

  has_many :following_relationships, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :following_relationships, source: :followed
  has_many :followers, through: :following_relationships, source: :follower

  has_many :rent_records, class_name: "RentRecord", foreign_key: "user_id"
  has_many :borrows, through: :rent_records, source: :item

  has_many :collect_relationships, class_name: "ItemCollection", foreign_key: "user_id"
  has_many :collections, through: :collect_relationships, source: :item

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def follow!(user)
    following << user
  end

  def unfollow!(user)
    following.destroy(user)
  end

  def is_following?(user)
    following.include?(user)
  end

  def collect!(item)
    collections << item
  end

  def uncollect!(item)
    collections.destroy(item)
  end

  def is_collected?(item)
    collections.include?(item)
  end
end
