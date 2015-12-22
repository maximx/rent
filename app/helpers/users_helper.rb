module UsersHelper
  def render_follow_link(user)
    if can? :follow, user
      link_to render_icon_with_text('star-empty', t('controller.users.action.follow')),
              follow_user_path(user),
              method: :put, class: 'btn btn-default follow-user'
    end
  end

  def render_unfollow_link(user)
    if can? :unfollow, user
      link_to render_icon_with_text('star', t('controller.users.action.unfollow')),
              unfollow_user_path(user),
              method: :delete, class: 'btn btn-default follow-user'
    end
  end

  def render_icon_confirmed
    render_icon 'ok', class: 'text-success', data: { toggle: 'tooltip' }, title: t('helpers.users.confirmed_attribute')
  end

  def user_navbar_list(user)
    render_link_li class: 'nav navbar-nav navbar-right' do |li|
      li << [ t('controller.users.action.show', name: user.profile.logo_name), user_path(user) ]
      li << [ t('controller.users.action.reviews'), reviews_user_path(user) ]
      li << [ t('controller.users.action.items'), items_user_path(user) ]
      li << [ content_tag(:strong, t('rent.site_name'), class: 'text-danger'), items_path ]
    end
  end

  def users_controller?
    controller_path == 'users'
  end
end
