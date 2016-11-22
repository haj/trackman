class NotificationsController < ApplicationController
  # Include module / class
  load_and_authorize_resource

  # Callback controller
  before_action :set_notification, only: [:show, :destroy]

  # GET /notifications/:id || notification_path(:id)
  # Show specific notification
  def show 
    respond_with(@notification)
  end

  # DELETE /notifications/:id || notification_path(:id)
  # Delete speciic notification
  def destroy
    @notification.destroy

    respond_with(@notification, location: notifications_user_path(current_user))
  end

  # UNUSED METHOD
  def trash
    notification.move_to_trash(current_user)
    redirect_to :notifications
  end

  def untrash
    notification.untrash(current_user)
    redirect_to :notifications
  end
  
  private

  def set_notification
    @notification = current_user.mailbox.notifications.find(params[:id])    
  end

  def conversation_params
    params.require(:conversation).permit(:body, :subject, :recipient_id)
  end

end