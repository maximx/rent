class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can [ :read, :reviews, :lender_reviews, :borrower_reviews, :items ], User
    can [ :update, :avatar ], User do |instance_user|
      instance_user == user
    end
    can [ :follow ], User do |instance_user|
      instance_user != user and !user.following?(instance_user)
    end
    can [ :unfollow ], User do |instance_user|
      instance_user != user and user.following?(instance_user)
    end
  end
end
