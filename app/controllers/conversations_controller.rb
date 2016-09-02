class ConversationsController < ApplicationController
  #load_and_authorize_resource

  # Callback controller
  before_action :set_conversation, only: [:reply, :destroy]

  add_breadcrumb "Conversations", :conversations_url

  # GET /conversations || conversations_path
  # Show all conversations
  def index
    add_breadcrumb "Inbox"

    @conversations = 
      if params[:read].present? && params[:read] == "true"
        current_user.mailbox.inbox(:read => true)
      elsif params[:read].present? && params[:read] == "false"
        current_user.mailbox.inbox(:unread => true)
      else 
        current_user.mailbox.inbox
      end.page(params[:page])
  
    respond_with(@conversations)
  end

  # GET /conversations/:id || conversation_path(:id)
  # Show specific conversation
  def show
    @conversation = current_user.mailbox.conversations.find(params[:id])
    @conversation.mark_as_read(current_user)

    respond_with(@conversation)
  end

  # GET /conversations/new || new_conversation_path
  # New Conversation Form
  def new
    @conversation = Mailboxer::Conversation.new

    respond_with(@conversation)
  end

  # POST /conversations || conversations_path
  # Create a brand new conversation
  def create
    recipient     = User.find(conversation_params['recipient_id'])
    @conversation = current_user.send_message(recipient, conversation_params['body'], conversation_params['subject']).conversation

    respond_with(@conversation, location: conversation_path(@conversation))
  end

  # DELETE /conversations/:id || conversation_path(:id)
  # Delete specific conversation
  def destroy
    @conversation.destroy

    respond_with(@conversation, location: conversations_user_path(current_user))
  end

  # GET /conversations/mark_as_action || mark_as_action_conversations_path
  # Mark as action 
  def mark_as_action
    @conversation = UserConversation.mark_as_action(params[:clicked_action], params[:conversation_ids], current_user.try(:id))

    respond_with(@conversation, location: conversations_path)
  end

  # GET /conversations/sent_box || sentbox_conversations_path
  # Show all sent box conversation
  def sentbox 
    add_breadcrumb "Sentbox"

    @sentbox = current_user.mailbox.sentbox

    respond_with(@sentbox)
  end

  # POST /conversations/:id/reply || reply_conversation(:id)
  # Reply to an existing conversation
  def reply
    current_user.reply_to_conversation(@conversation, conversation_params['body'])

    @message = @conversation.messages.last

    respond_to do |format|
      format.js
    end
  end

  def trash
    @conversation.move_to_trash(current_user)
    redirect_to :conversations
  end

  def untrash
    @conversation.untrash(current_user)
    redirect_to :conversations
  end

  private

  def conversation_params
    params.require(:conversation).permit(:body, :subject, :recipient_id)
  end

  def set_conversation
    @conversation = current_user.mailbox.conversations.find(params[:id])    
  end

end