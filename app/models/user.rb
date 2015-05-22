class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :items
  has_many :questions
  has_many :follow_relationships, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :following, throught: :follow_relationships, source: :followed
  has_many :followers, throught: :follow_relationships, source: :follower

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def follow!(user)
    follow_relationships << user
  end

  def unfollow!(user)
    follow_relationships.destroy(user)
  end

  def following?(user)
    following.include?(user)
  end
end
