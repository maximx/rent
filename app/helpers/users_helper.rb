module UsersHelper
  def render_follow_link(user, type = "")
    if current_user && current_user.is_following?(user)
      link_to("取消追蹤", unfollow_user_path(user), method: :delete, class: "btn btn-default unfollow-user", remote: is_remote?(type))
    else
      link_to("追蹤", follow_user_path(user), method: :post, class: "btn btn-primary")
    end
  end

end
