class AddArchivedToAlarmNotifications < ActiveRecord::Migration
  def change
    add_column :alarm_notifications, :archived, :boolean, default: false
  end
end
