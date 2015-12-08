class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    read_only
    resources_users user
    resources_items user
  end

  protected
    def read_only
      can [ :read, :reviews, :lender_reviews, :borrower_reviews, :items ], User
      can [ :read, :create, :questions, :search, :calendar ], Item
    end

    def resources_users(user)
      can [ :update, :avatar ], User, id: user.id
      can :follow, User do |instance_user|
        instance_user != user and !user.following?(instance_user)
      end
      can :unfollow, User do |instance_user|
        instance_user != user and user.following?(instance_user)
      end
    end

    def resources_items(user)
      can :update, Item, lender: user
      can :collect, Item do |item|
        !user.collected?(item)
      end
      can :uncollect, Item do |item|
        user.collected?(item)
      end
      can :open, Item, lender: user, closed?: true
      can :close, Item, lender: user, opening?: true
      can :destroy, Item do |item|
        item.lender == user and item.records.empty?
      end
    end
end
