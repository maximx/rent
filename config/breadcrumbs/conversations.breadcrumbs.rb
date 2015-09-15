crumb :conversations do
  link '收件匣', conversations_path
end

crumb :conversation do |conversation|
  link '交談', conversation_path(conversation)
  parent :conversations
end
