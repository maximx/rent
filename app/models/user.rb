class User < ActiveRecord::Base
  rolify
  attr_accessor :login

  validates :account, presence: true, uniqueness: { case_sensitive: false }, format: { with: /\A[\w]*\z/ }
  validates :agreement, acceptance: true

  has_one :profile, as: :user
  has_many :requirements
  has_many :customers

  has_many :following_relationships, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :following_relationships, source: :followed
  has_many :followers, through: :following_relationships, source: :follower

  has_many :items
  has_many :records, as: :borrower
  has_many :lend_records, through: :items, class_name: 'Record', source: :records
  has_many :borrowers, through: :lend_records, source: :borrower, source_type: 'User'

  has_many :orders, as: :borrower
  has_many :lend_orders, ->{uniq}, through: :lend_records, class_name: 'Order', source: :order

  has_many :collect_relationships, class_name: "ItemCollection", foreign_key: "user_id"
  has_many :collections, through: :collect_relationships, source: :item

  has_many :revieweds, class_name: "Review", foreign_key: "judger_id"
  has_many :reviews, class_name: "Review", foreign_key: "user_id"

  has_many :covers, class_name: 'Attachment', as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :covers

  has_many :vectors
  has_many :subcategories, through: :vectors

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

  def to_param
    account
  end

  # mailboxer
  def mailboxer_email(object)
    email if profile.send_mail
  end

  def consumers(options = {})
    (
      customers.includes(:profile).where(options) +
      borrowers.includes(:profile).where(options)
    ).uniq
  end

  # user follow
  def follow!(user)
    followings << user
  end

  def unfollow!(user)
    followings.destroy(user)
  end

  def following?(user)
    followings.include?(user)
  end

  # item collect
  def collect!(item)
    collections << item
  end

  def uncollect!(item)
    collections.destroy(item)
  end

  def collected?(item)
    collections.include?(item)
  end

  def reviews_of(role)
    role = Review.user_roles[role.to_s]
    reviews.where(user_role: role).order(:created_at).reverse_order
  end

  def role_of(record)
    if self == record.lender
      return "lender"
    elsif self == record.borrower
      return "borrower"
    end
  end

  def avatar_url
    if profile.avatar.present?
      profile.avatar.image.url
    else
      region = 's3-ap-southeast-1'
      host = 'amazonaws.com'
      bucket = 'guangho-file'
      "https://#{region}.#{host}/#{bucket}/default-avatar.gif"
    end
  end

  def meta_description
    profile.description || "您好，我是#{account}，我在#{I18n.t('rent.site_name')}"
  end

  def unread_count
    mailbox.inbox(unread: true).count + mailbox.notifications(unread: true).count
  end

  def is_customer?
    self.is_a? Customer
  end

  def logo_name
    profile.logo_name
  end

  private
    def init_profile
      self.build_profile.save(validate: false) unless profile
    end
end
