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

  def user_navbar_list(user)
    render_link_li class: 'nav navbar-nav navbar-right' do |li|
      li << [ '關於', user_path(user) ]
      li << [ '評價', reviews_user_path(user) ]
      li << [ '出租物', items_user_path(user) ]
      li << [ content_tag(:strong, '編輯', class: 'text-primary'), edit_user_path(user) ] if display_edit_user_link? user
      li << [ content_tag(:strong, Rent::SITE_NAME, class: 'text-danger'), items_path ]
    end
  end

  def display_edit_user_link?(user)
    current_user == user and users_controller? and !edit_action?
  end

  def users_controller?
    params[:controller] == 'users'
  end
end
