class CreateAlarmsGroupsTable < ActiveRecord::Migration
  def change
    create_table :alarms_groups do |t|
  		t.references :group, :null => false
  		t.references :alarm, :null => false
  		t.string :status
  		t.datetime :last_alert
	end

	# Adding the index can massively speed up join tables. Don't use the
	# unique if you allow duplicates.
	add_index(:alarms_groups, [:group_id, :alarm_id], :unique => true)
  end
end
