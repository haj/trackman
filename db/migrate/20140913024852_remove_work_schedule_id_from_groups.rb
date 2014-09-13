class RemoveWorkScheduleIdFromGroups < ActiveRecord::Migration
  def change
  	remove_column :groups, :work_schedule_id
  end
end
