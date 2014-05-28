class CreateAlarmsRulesTable < ActiveRecord::Migration
  def change
	    create_table :alarms_rules do |t|
	  		t.references :rule, :null => false
	  		t.references :alarm, :null => false
	  		t.string :conjunction
	  		t.string :params
		end

		add_index(:alarms_rules, [:alarm_id, :rule_id], :unique => true)
	  
  	end
end
