class ReplaceCarIdWithWorkScheduleIdInWorkHoursTable < ActiveRecord::Migration
  def change
  	remove_column :work_hours, :car_id
  	add_column :work_hours, :work_schedule_id, :integer
    add_index :work_hours, :work_schedule_id
  end
end
