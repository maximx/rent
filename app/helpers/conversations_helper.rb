module ConversationsHelper
  def render_conversation_subject(conversation)
    conversation.is_unread?(current_user) ?
      content_tag(:strong, conversation.subject) : conversation.subject
  end

  def conversations_navbar_list
    render_link_li class: 'nav navbar-nav' do |li|
      li << [ render_icon_with_text('bell', '通知'), notifications_path ]
      li << [ render_icon_with_text('eye-open', '未讀訊息'), unread_conversations_path ]
      li << [ render_icon_with_text('inbox', '收件匣'), conversations_path ]
    end
  end
end
