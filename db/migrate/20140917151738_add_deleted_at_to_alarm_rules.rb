class AddDeletedAtToAlarmRules < ActiveRecord::Migration
  def change
    add_column :alarms_rules, :deleted_at, :datetime
    add_index :alarms_rules, :deleted_at
  end
end
