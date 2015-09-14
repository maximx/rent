module ConversationsHelper
  def render_conversation_subject(conversation)
    conversation.is_unread?(current_user) ?
      content_tag(:strong, conversation.subject) : conversation.subject
  end
end
