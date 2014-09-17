class AddDeletedAtToAlarms < ActiveRecord::Migration
  def change
    add_column :alarms, :deleted_at, :datetime
    add_index :alarms, :deleted_at
  end
end
