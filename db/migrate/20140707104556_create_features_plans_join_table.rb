class CreateFeaturesPlansJoinTable < ActiveRecord::Migration
  def change
  	create_table :features_plans do |t|
	  		t.references :feature, :null => false
	  		t.references :plan, :null => false
	  		t.string :active
		end

		add_index(:features_plans, [:feature_id, :plan_id], :unique => true)
  end
end
