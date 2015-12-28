module NotificationsHelper
  def render_notifications_link
    icon = render_icon('comment', title: '通知與訊息', data: { toggle: 'tooltip', placement: 'bottom' })
    badge = content_tag(:span, current_user.unread_count, class: 'badge')

    link_to(icon + badge, notifications_path, class: 'icon-navbar')
  end
end
