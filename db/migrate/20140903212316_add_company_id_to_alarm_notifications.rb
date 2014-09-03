class AddCompanyIdToAlarmNotifications < ActiveRecord::Migration
  def change
    add_column :alarm_notifications, :company_id, :integer
  end
end
