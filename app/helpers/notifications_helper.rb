module NotificationsHelper
  def render_notification_subject(notification)
    notification.is_unread?(current_user) ?
      content_tag(:strong, notification.subject) : notification.subject
  end

  def notifications_navbar_list
    render_link_li class: 'nav navbar-nav' do |li|
      li << [ render_icon_with_text('bell', '通知'), notifications_path ]
    end
  end

  def render_notifications_link
    unread_count = current_user.unread_count
    options = {title: '通知', data: {toggle: 'tooltip', placement: 'bottom'}}
    options.merge!({class: 'text-info'}) if unread_count > 0

    icon = render_icon('bell', options)
    badge = content_tag(:span, unread_count, class: 'badge')

    link_to(icon + badge, notifications_path, class: 'icon-navbar')
  end
end
