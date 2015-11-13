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
    render_link_li class: 'nav nav-tabs nav-justified anchor', role: 'tablist', id: 'reviews-follows' do |li|
      li << [ '評價', user_path(user, anchor: 'reviews-follows') ]
      li << [ '關注', follows_user_path(user, anchor: 'reviews-follows') ]
    end
  end

  def user_navbar_list(user)
    render_link_li class: 'nav navbar-nav navbar-right' do |li|
      li << [ '關於', user_path(user) ]
      li << [ '評價', reviews_user_path(user) ]
      li << [ '出租物', items_user_path(user) ]
      li << [ '預約到店', '#' ]
    end
  end
end
