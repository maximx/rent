module ConversationsHelper
  def render_conversation_subject(conversation)
    conversation.is_unread?(current_user) ?
      content_tag(:strong, conversation.subject) : conversation.subject
  end

  def render_unread_link
    badge = content_tag(:span, current_user.inbox_unread_count, class: 'badge')

    link_to(render_icon('envelope') + badge,
            unread_conversations_path,
            class: 'conversations-icon', title: '訊息', data: { toggle: 'tooltip', placement: 'bottom' })
  end
end
