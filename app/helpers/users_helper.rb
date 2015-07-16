module UsersHelper
  def render_follow_link(user, type = "")
    if current_user && current_user.is_following?(user)
      render_unfollow_link(user, type)
    else
      link_to("追蹤", follow_user_path(user), method: :post, class: "btn btn-primary")
    end
  end

  def render_unfollow_link(user, type = "")
    type = (type.to_sym == :remote)
    link_to("取消追蹤", unfollow_user_path(user), method: :delete, class: "btn btn-default unfollow-user", remote: type)
  end
end
