class AddDeletedAtToWorkHours < ActiveRecord::Migration
  def change
    add_column :work_hours, :deleted_at, :datetime
    add_index :work_hours, :deleted_at
  end
end
