class CreateFeaturesPlanTypesJoinTable < ActiveRecord::Migration
  def change
  	drop_table :features_plans
  	create_table :features_plan_types do |t|
	  		t.references :feature, :null => false
	  		t.references :plan_type, :null => false
	  		t.string :active
		end

		add_index(:features_plan_types, [:feature_id, :plan_type_id], :unique => true)
  end
end
