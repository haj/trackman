class ConversationsController < ApplicationController
  #load_and_authorize_resource

  before_action :set_conversation, only: [:reply, :destroy]


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
  end

  def show
    @conversation = current_user.mailbox.conversations.find(params[:id])
    @conversation.mark_as_read(current_user)
  end

  def new
    @conversation = Mailboxer::Conversation.new
  end

  # Create a brand new conversation
  def create
    recipient = User.find(conversation_params['recipient_id'])
    @conversation = current_user.send_message(recipient, conversation_params["body"], conversation_params["subject"]).conversation
    redirect_to conversation_path(@conversation)
  end

  def mark_as_action
    UserConversation.mark_as_action(params[:clicked_action], params[:conversation_ids], current_user.try(:id))

    redirect_to conversations_path
  end

  def sentbox 
    @sentbox = current_user.mailbox.sentbox
  end

  # Reply to an existing conversation
  def reply
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
    @conversation.destroy
    redirect_to conversations_user_path(current_user)
  end

  private

  def conversation_params
    params.require(:conversation).permit(:body, :subject, :recipient_id)
  end

  def set_conversation
    @conversation = current_user.mailbox.conversations.find(params[:id])    
  end

end