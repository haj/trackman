class NotificationsController < ApplicationController
  add_breadcrumb "Notifications", :notifications_url

  # Callback controller
  before_action :set_notification, only: [:show, :destroy, :mark_as_read]

  # GET /notifications || notifications_path
  # Show all notifications
  def index
    add_breadcrumb "Index"

    @notifications = current_user.notifications.order(created_at: :desc).page(params[:page])

    respond_with(@notifications)
  end

  # DELETE /notifications/:id || notification_path(:id)
  # Delete speciic notification
  def destroy
    @notification.destroy

    respond_with(@notification, location: notifications_user_path(current_user))
  end

  def mark_as_read
    @notification.update(is_read: true)

    respond_to :js
  end

  private

  def set_notification
    @notification = current_user.notifications.find(params[:id])    
  end
end