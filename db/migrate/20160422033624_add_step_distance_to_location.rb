class AddStepDistanceToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :step_distance, :float
  end
end
