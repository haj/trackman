class CreateGroupsRulesJoinTable < ActiveRecord::Migration
  def change
    create_table :groups_rules, :id => false do |t|
  		t.references :group, :null => false
  		t.references :rule, :null => false
  		t.string :status
  		t.datetime :last_alert
	end

	# Adding the index can massively speed up join tables. Don't use the
	# unique if you allow duplicates.
	add_index(:groups_rules, [:group_id, :rule_id], :unique => true)
  end
end
