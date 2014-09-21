class AddNameToWorkScheduleGroup < ActiveRecord::Migration
  def change
    add_column :work_schedule_groups, :name, :string
  end
end
