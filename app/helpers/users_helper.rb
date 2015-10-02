module UsersHelper
  def render_follow_link(user, type = '')
    format = (is_remote? type) ? 'json' : ''
    if user_signed_in? && current_user.is_following?(user)
      link_to render_icon_with_text('star', '取消追蹤'),
              unfollow_user_path(user, format: format),
              remote: is_remote?(type), method: :delete, class: 'btn btn-default follow-user'
    elsif current_user != user
      link_to render_icon_with_text('star-empty', '追蹤'),
              follow_user_path(user, format: format),
              remote: is_remote?(type), method: :put, class: 'btn btn-default follow-user'
    end
  end
end
