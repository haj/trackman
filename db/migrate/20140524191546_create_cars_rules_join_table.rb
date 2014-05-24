class CreateCarsRulesJoinTable < ActiveRecord::Migration
  def change
  	
    create_table :cars_rules, :id => false do |t|
  		t.references :car, :null => false
  		t.references :rule, :null => false
  		t.string :status
  		t.datetime :last_alert
    end

	add_index(:cars_rules, [:car_id, :rule_id], :unique => true)

  end
end
