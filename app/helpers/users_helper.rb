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

  def render_user_reviews_follows(user)
    render_link_li class: 'nav nav-tabs nav-justified', role: 'tablist' do |li|
      li << [ '評價', user_path(user) ]
      li << [ '關注', follows_user_path(user) ]
    end
  end
end
