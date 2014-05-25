class CreateConditionsRulesTable < ActiveRecord::Migration
  
  	def change
	    create_table :conditions_rules do |t|
	  		t.references :rule, :null => false
	  		t.references :condition, :null => false
	  		t.string :conjunction
		end

		add_index(:conditions_rules, [:condition_id, :rule_id], :unique => true)
	  
  	end
  	
end
