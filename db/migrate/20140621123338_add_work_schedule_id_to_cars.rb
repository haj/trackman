class AddWorkScheduleIdToCars < ActiveRecord::Migration
  def change
    add_column :cars, :work_schedule_id, :integer
  end
end
