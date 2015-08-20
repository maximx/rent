module UsersHelper
  def render_follow_link(user, type = "")
    if user_signed_in? && current_user.is_following?(user)
      link_to(render_icon_with_text('star', '取消追蹤'), unfollow_user_path(user),
              method: :delete, class: 'btn btn-default unfollow-user', remote: is_remote?(type))
    elsif current_user != user
      link_to(render_icon_with_text('star-empty', '追蹤'), follow_user_path(user), method: :post, class: 'btn btn-default')
    end
  end
end
