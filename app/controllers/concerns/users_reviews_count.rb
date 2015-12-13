module UsersReviewsCount
  private
    def find_users_reviews_count
      @users_reviews_count = Review.lender
                            .where(user_id: @items.pluck(:user_id).uniq)
                            .group(:user_id, :rate).count
    end
end
