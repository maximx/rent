class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    read_only
    resources_users user
    resources_items user
    resources_records user
    resources_customers user if user.has_role? :company
    resources_reviews user
    resources_attachments user
  end

  protected
    def read_only
      can [ :read, :reviews, :lender_reviews, :borrower_reviews, :items ], User
      can [ :read, :create, :search, :calendar, :records ], Item
      can :index, Record
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

    def resources_records(user)
      can :show, Record do |record|
        record.viewable_by? user
      end
      can :create, Record do |record|
        record.lender != user and record.item.opening?
      end
      can :withdrawing, Record do |record|
        record.editable_by?(user)
      end
      can :remitting, Record do |record|
        record.editable_by?(user) and record.may_remit?
      end
      can :delivering, Record, lender: user, may_delivery?: true
      can :renting, Record, lender: user, may_rent?: true
      can :returning, Record, lender: user, may_return?: true
      can :ask_for_review, Record do |record|
        record.viewable_by?(user) and record.returned? and
          record.judgers.include?(user) and record.reviews.size == 1
      end
    end

    def resources_customers(user)
      can [ :read, :create ], Customer
      can :update, Customer, user: user
    end

    def resources_reviews(user)
      can :create, Review do |review|
        review.record.viewable_by?(user) and review.record.returned? and
          !review.record.judgers.include?(user)
      end
    end

    def resources_attachments(user)
      can :destroy, Attachment do |attachment|
        attachment.editable_by? user
      end
      can :download, Attachment do |attachment|
        attachment.viewable_by? user
      end
    end
end