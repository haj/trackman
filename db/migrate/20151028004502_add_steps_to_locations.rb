class AddStepsToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :step, :integer, :null => true
  end
end
