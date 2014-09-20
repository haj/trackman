class AlarmNotificationsController < ApplicationController
  before_action :set_alarm_notification, only: [:edit, :update, :destroy, :show]

 load_and_authorize_resource :except => [:create]


  def index
    @alarm_notifications = AlarmNotification.where(archived: false).order("created_at DESC")
  end

  def show
  end

  def destroy
    @alarm_notification.destroy
    redirect_to alarm_notifications_url, notice: 'Alarm notification was successfully destroyed.'
  end

  def batch_archive
    alarm_notification_ids = params[:alarm_notification_ids]
    alarm_notification_ids.each do |alarm_notification_id|
      @alarm_notification = AlarmNotification.find(alarm_notification_id)
      @alarm_notification.update_attribute(:archived, true)
    end
    redirect_to alarm_notifications_path
  end

  def archive
    @alarm_notification = AlarmNotification.find(params[:id])
    @alarm_notification.update_attribute(:archived, true)
    redirect_to alarm_notifications_path
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
