module UsersHelper
  def render_follow_link(user)
    if current_user && current_user.is_following?(user)
      follow_link = link_to("取消追蹤", unfollow_user_path(user), method: :delete)
    else
      follow_link = link_to("追蹤", follow_user_path(user), method: :post)
    end
  end
end
