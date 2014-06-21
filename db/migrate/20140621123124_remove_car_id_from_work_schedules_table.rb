class RemoveCarIdFromWorkSchedulesTable < ActiveRecord::Migration
  def change
  	remove_column :work_schedules, :car_id
  end
end
