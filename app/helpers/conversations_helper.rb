module ConversationsHelper
  def render_conversation_subject(conversation)
    conversation.is_unread?(current_user) ?
      content_tag(:strong, conversation.subject) : conversation.subject
  end

  def render_inbox_link
    badge = content_tag(:span, current_user.inbox_unread_count, class: 'badge')
    link_text = render_icon('envelope') + badge
    link_to(link_text, conversations_path, class: 'conversations-icon')
  end
end
