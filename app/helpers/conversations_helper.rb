module ConversationsHelper
  def render_conversation_subject(conversation)
    conversation.is_unread?(current_user) ?
      content_tag(:strong, conversation.subject) : conversation.subject
  end

  def render_unread_link
    icon = render_icon('envelope', title: '未讀訊息', data: { toggle: 'tooltip', placement: 'bottom' })
    badge = content_tag(:span, current_user.inbox_unread_count, class: 'badge')

    link_to(icon + badge, unread_conversations_path, class: 'conversations-icon')
  end

  def conversations_navbar_list
    render_link_li class: 'nav navbar-nav' do |li|
      li << [ render_icon_with_text('eye-open', '未讀訊息'), unread_conversations_path ]
      li << [ render_icon_with_text('inbox', '收件匣'), conversations_path ]
    end
  end
end
