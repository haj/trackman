class AddDeletedAtToWorkSchedules < ActiveRecord::Migration
  def change
    add_column :work_schedules, :deleted_at, :datetime
    add_index :work_schedules, :deleted_at
  end
end
