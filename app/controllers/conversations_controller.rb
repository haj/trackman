class ConversationsController < ApplicationController
  
  #load_and_authorize_resource


  def show
    @conversation = current_user.mailbox.conversations.find(params[:id])
    @conversation.mark_as_read(current_user)
  end

  def new
    @conversation = Mailboxer::Conversation.new
  end

  def index
    if params[:read].present? && params[:read] == "true"
      @conversations = current_user.mailbox.inbox(:read => true)
      @inbox_title = "Inbox (Read)"
    elsif params[:read].present? && params[:read] == "false"
      @conversations = current_user.mailbox.inbox(:unread => true)
      @inbox_title = "Inbox (Unread)"
    else 
      @conversations = current_user.mailbox.inbox
      @inbox_title = "Inbox (All)"
    end

    @sentbox = current_user.mailbox.sentbox
  end

  

  # Create a brand new conversation
  def create
    recipient = User.find(conversation_params['recipient_id'])
    @conversation = current_user.send_message(recipient, conversation_params["body"], conversation_params["subject"]).conversation
    redirect_to conversation_path(@conversation)
  end

  def mark_as_action
    conversation_ids = params[:conversation_ids]
    clicked_action = params[:clicked_action]
    UserConversation.mark_as_action(clicked_action, conversation_ids, current_user.id)
    redirect_to conversations_path
  end


  # Reply to an existing conversation
  def reply
    @conversation = current_user.mailbox.conversations.find(params[:id])
    current_user.reply_to_conversation(@conversation, conversation_params['body'])
    redirect_to conversation_path(@conversation)
  end

  def trash
    @conversation.move_to_trash(current_user)
    redirect_to :conversations
  end

  def untrash
    @conversation.untrash(current_user)
    redirect_to :conversations
  end

  

  def destroy
    @conversation = current_user.mailbox.conversations.find(params[:id])
    @conversation.destroy
    redirect_to conversations_user_path(current_user)
  end

  private

  def conversation_params
    params.require(:conversation).permit(:body, :subject, :recipient_id)
  end

end