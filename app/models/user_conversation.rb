class UserConversation
  def self.mark_as_action(clicked_action, conversation_ids, user_id)
    user = User.find(user_id)

    conversation_ids.each do |conversation_id|
      @conversation = Mailboxer::Conversation.find(conversation_id.to_i)
      if clicked_action == "mark_as_read"
        @conversation.mark_as_read(user)
        Rails.logger.warn "mark_as_read"
        
      elsif clicked_action == "mark_as_unread"
        @conversation.mark_as_unread(user)
        Rails.logger.warn "mark_as_unread"

      elsif clicked_action == "mark_as_deleted"
        @conversation.mark_as_deleted(user)
        Rails.logger.warn "mark_as_deleted"
      end
    end
  end
end