module ConversationsHelper
  def inbox_title(read)
    case read
    when 'true'
      'Inbox (Read)'
    when 'false'
      'Inbox (Unread)'
    else
      'Inbox (All)'
    end
  end
end
