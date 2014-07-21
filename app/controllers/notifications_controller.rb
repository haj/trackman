class NotificationsController < ApplicationController
  load_and_authorize_resource

  def trash
    notification.move_to_trash(current_user)
    redirect_to :notifications
  end

  def untrash
    notification.untrash(current_user)
    redirect_to :notifications
  end

  def show
    @notification = current_user.mailbox.notifications.find(params[:id])
  end

  def destroy
    @notification = current_user.mailbox.notifications.find(params[:id])
    @notification.destroy
    redirect_to notifications_user_path(current_user)
  end

  private

  def conversation_params
    params.require(:conversation).permit(:body, :subject, :recipient_id)
  end

end