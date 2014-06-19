class CreateAlarmsCarsTable < ActiveRecord::Migration
  def change
    create_table :alarms_cars do |t|
  		t.references :car, :null => false
  		t.references :alarm, :null => false
  		t.string :status
  		t.datetime :last_alert
	end

	# Adding the index can massively speed up join tables. Don't use the
	# unique if you allow duplicates.
	add_index(:alarms_cars, [:car_id, :alarm_id], :unique => true)
  end
end
