class User < ActiveRecord::Base
  extend I18nMessage

  attr_accessor :login

  validates :account, presence: true, uniqueness: { case_sensitive: false }, format: { with: /\A[\w]*\z/ }
  validates :agreement, acceptance: true

  has_one :profile, as: :user
  has_many :questions
  has_many :requirements
  has_many :customers

  has_many :following_relationships, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :following_relationships, source: :followed
  has_many :followers, through: :following_relationships, source: :follower

  has_many :items
  has_many :rent_records, through: :items
  has_many :borrowers, through: :rent_records, source_type: 'User'
  alias_method :lend_records, :rent_records

  has_many :borrow_records, class_name: 'RentRecord', as: :borrower

  has_many :collect_relationships, class_name: "ItemCollection", foreign_key: "user_id"
  has_many :collections, through: :collect_relationships, source: :item

  has_many :revieweds, class_name: "Review", foreign_key: "judger_id"
  has_many :reviews, class_name: "Review", foreign_key: "user_id"

  has_many :covers, class_name: 'Picture', as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :covers

  after_save :init_profile

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, authentication_keys: [:login]

  acts_as_messageable

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where("account = :value OR email = :value", value: login).first
    else
      where(conditions.to_h).first
    end
  end

  # mailboxer
  def mailboxer_email(object)
    email
  end

  def consumers
    (customers + borrowers).uniq
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

  def reviews_of(role)
    role = Review.user_roles[role.to_s]
    reviews.where(user_role: role).order(:created_at).reverse_order
  end

  def role_of(rent_record)
    if self == rent_record.lender
      return "lender"
    elsif self == rent_record.borrower
      return "borrower"
    end
  end

  def picture_url
    public_id = ApplicationController.helpers.public_id_of(self)
    Cloudinary::Utils.cloudinary_url(public_id)
  end

  def meta_description
    profile.description || "您好，我是#{account}，我在#{Rent::SITE_NAME}"
  end

  def unread_count
    mailbox.inbox(unread: true).count + mailbox.notifications(unread: true).count
  end

  def is_customer?
    self.is_a? Customer
  end

  private

    def init_profile
      self.build_profile.save(validate: false) unless profile
    end
end
