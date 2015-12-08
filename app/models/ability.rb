class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user

    # resources users
    can [ :read, :reviews, :lender_reviews, :borrower_reviews, :items ], User
    can [ :update, :avatar ], User do |instance_user|
      instance_user == user
    end
    can :follow, User do |instance_user|
      instance_user != user and !user.following?(instance_user)
    end
    can :unfollow, User do |instance_user|
      instance_user != user and user.following?(instance_user)
    end

    # resources users
    can [ :read, :create, :questions, :search, :calendar ], Item
    can :update, Item do |item|
      item.lender == user
    end
    can :collect, Item do |item|
      !user.collected?(item)
    end
    can :uncollect, Item do |item|
      user.collected?(item)
    end
    can :open, Item do |item|
      item.lender == user and item.closed?
    end
    can :close, Item do |item|
      item.lender == user and item.opening?
    end
    can :destroy, Item do |item|
      item.lender == user and item.records.empty?
    end
  end
end
