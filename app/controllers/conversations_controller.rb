class ConversationsController < ApplicationController


  def new
    # render text: params
    # return 
    @conversation = Mailboxer::Conversation.new
  end

  # Create a brand new conversation
  def create
    # render text: params
    # return 
    
    recipient = User.find(conversation_params['recipient_id'])
    @conversation = current_user.send_message(recipient, conversation_params["body"], conversation_params["subject"]).conversation
    redirect_to conversation_path(@conversation)
  end

  # Reply to an existing conversation
  def reply
    @conversation = current_user.mailbox.conversations.find(params[:id])
    current_user.reply_to_conversation(@conversation, conversation_params['body'])
    redirect_to @conversation
  end

  def trash
    conversation.move_to_trash(current_user)
    redirect_to :conversations
  end

  def untrash
    conversation.untrash(current_user)
    redirect_to :conversations
  end

  def show
    @conversation = current_user.mailbox.conversations.find(params[:id])
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