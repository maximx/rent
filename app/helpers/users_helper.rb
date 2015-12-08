module UsersHelper
  def render_follow_link(user)
    if can? :follow, user
      link_to render_icon_with_text('star-empty', '追蹤'),
              follow_user_path(user),
              method: :put, class: 'btn btn-default follow-user'
    end
  end

  def render_unfollow_link(user)
    if can? :unfollow, user
      link_to render_icon_with_text('star', '取消追蹤'),
              unfollow_user_path(user),
              method: :delete, class: 'btn btn-default follow-user'
    end
  end

  def user_navbar_list(user)
    render_link_li class: 'nav navbar-nav navbar-right' do |li|
      li << [ content_tag(:strong, t('helpers.submit.edit'), class: 'text-primary'), edit_user_path(user) ] if can?(:edit, user)
      li << [ '關於', user_path(user) ]
      li << [ '評價', reviews_user_path(user) ]
      li << [ '出租物', items_user_path(user) ]
      li << [ content_tag(:strong, t('rent.site_name'), class: 'text-danger'), items_path ]
    end
  end

  def users_controller?
    params[:controller] == 'users'
  end
end
