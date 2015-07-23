class User < ActiveRecord::Base
  attr_accessor :login

  validates_presence_of :account, uniqness: true

  has_one :profile
  has_many :items
  has_many :questions
  has_many :requirements

  has_many :following_relationships, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :following_relationships, source: :followed
  has_many :followers, through: :following_relationships, source: :follower

  has_many :rent_records, class_name: "RentRecord", foreign_key: "user_id"
  has_many :borrows, through: :rent_records, source: :item

  has_many :collect_relationships, class_name: "ItemCollection", foreign_key: "user_id"
  has_many :collections, through: :collect_relationships, source: :item

  has_many :revieweds, class_name: "Review", foreign_key: "judger_id"
  has_many :reviews, class_name: "Review", foreign_key: "user_id"

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, authentication_keys: [:login]

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where("account = :value OR email = :value", value: login).first
    else
      where(conditions.to_h).first
    end
  end

  # user follow
  def follow!(user)
    following << user
  end

  def unfollow!(user)
    following.destroy(user)
  end

  def is_following?(user)
    following.include?(user)
  end

  # item collect
  def collect!(item)
    collections << item
  end

  def uncollect!(item)
    collections.destroy(item)
  end

  def is_collected?(item)
    collections.include?(item)
  end

  # rent record review
  def lender_reviews
    user_role = Review.user_roles["lender"]
    reviews.where(user_role: user_role).order("created_at DESC")
  end

  def borrower_reviews
    user_role = Review.user_roles["borrower"]
    reviews.where(user_role: user_role).order("created_at DESC")
  end

  def role_of(rent_record)
    if self == rent_record.lender
      return "lender"
    elsif self == rent_record.borrower
      return "borrower"
    end
  end

  def meta_keywords
    KEYWORDS +  [ profile.name ]
  end

  def picture_url
    public_id = ApplicationController.helpers.public_id_of(self)
    Cloudinary::Utils.cloudinary_url(public_id)
  end
end
