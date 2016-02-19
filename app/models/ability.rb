class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    everyone_can
    resources_users user
    resources_items user
    resources_records user
    resources_reviews user
    resources_attachments user
    resources_orders user
    resources_order_lenders user

    #TODO: add company ability
    #if user.is_company?
    if user.persisted?
      can [ :importer, :import ], Item

      can [:index, :create], Customer
      can [:show,:update], Customer, user_id: user.id

      can :read, Category
      can :read, Subcategory

      can [ :read, :create ], Vector
      can [ :update, :destroy ], Vector, user_id: user.id

      can [ :read, :create ], Selection
      can [ :update, :destroy ], Selection, user_id: user.id
    end
  end

  protected
    def everyone_can
      can [:read, :reviews, :lender_reviews, :borrower_reviews, :items], User
      can [:read, :create, :search, :calendar, :remove], Item
      can :index, Record
      can :calendar, Order
    end

    def resources_users(user)
      can [:update, :avatar, :save], User, id: user.id
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
        !item.collected_by? user
      end
      can :uncollect, Item do |item|
        item.collected_by? user
      end
      can :open, Item, lender: user, closed?: true
      can :close, Item, lender: user, opening?: true
      can :destroy, Item do |item|
        item.user_id == user.id and item.records.empty?
      end
      can [:add], Item do |item|
        item.user_id != user.id
      end
    end

    def resources_records(user)
      can :show, Record do |record|
        record.viewable_by? user
      end
      can :create, Record do |record|
        record.lender != user and record.item.opening?
      end
      can :ask_for_review, Record do |record|
        record.viewable_by?(user) and record.returned? and
          record.judgers.include?(user) and record.reviews.size == 1
      end
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

    def resources_orders(user)
      can :index, Order, borrower: user
      can :show, Order do |order|
        order.borrower == user or order.lenders.pluck(:id).include?(user.id)
      end
    end

    def resources_order_lenders(user)
      can :show, OrderLender do |order_lender|
        order_lender.viewable_by? user
      end

      can :remitting, OrderLender do |order_lender|
        order_lender.editable_by?(user) and order_lender.may_remit?
      end
      can :withdrawing, OrderLender do |order_lender|
        order_lender.editable_by?(user) and order_lender.may_withdraw?
      end

      can :delivering, OrderLender, lender: user, may_delivery?: true
      can :renting,    OrderLender, lender: user, may_rent?:     true
      can :returning,  OrderLender, lender: user, may_return?:   true
    end
end
