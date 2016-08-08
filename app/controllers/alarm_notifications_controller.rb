class AlarmNotificationsController < ApplicationController
  # Initialize something from GEM
  load_and_authorize_resource :except => [:create]

  # Callback controller
  before_action :set_alarm_notification, only: [:edit, :update, :destroy, :show, :archive]

  # Respond Request
  respond_to :html

  # GET /alerts || alarm_notifications_path
  # List all alarm notifications
  def index
    @alerts = AlarmNotification.not_archieved.order("created_at DESC")

    respond_with(@alerts)
  end

  # GET /alerts/:id || alarm_notification_path(:id)
  # Show specific alarm
  def show
    respond_with(@alarm_notification)
  end

  # DELETE /alerts/:id || alarm_notification_path(:id)
  # Delete specific alarm
  def destroy
    @alarm_notification.destroy

    respond_with(@alarm_notification, location: alarm_notifications_url, notice: 'Alarm notification was successfully destroyed.')
  end

  # PUT /alerts/batch_archive || batch_archive_alarm_notifications_path
  # Archieve alarm notifications 
  def batch_archive
    alarm_notification_ids = params[:alarm_notification_ids]
    alarm_notification_ids.each do |alarm_notification_id|
      @alarm_notification = AlarmNotification.find(alarm_notification_id)
      @alarm_notification.update_attribute(:archived, true)
    end
    respond_with(@alarm_notification, location: alarm_notifications_path)
  end

  # GET /alerts/:id/archive || archive_alarm_notification_path(:id)
  # Archieve specific alarm notification 
  def archive
    @alarm_notification.update_attribute(:archived, true)
    respond_with(@alarm_notification, location: alarm_notifications_path)
  end

  private
  
  # Use callbacks to share common setup or constraints between actions.
  def set_alarm_notification
    @alarm_notification = AlarmNotification.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def alarm_notification_params
    params.require(:alarm_notification).permit!
  end
end
