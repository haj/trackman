class CreateAlarmNotifications < ActiveRecord::Migration
  def change
    create_table :alarm_notifications do |t|
      t.integer :car_id
      t.integer :driver_id
      t.integer :alarm_id

      t.timestamps
    end
  end
end
