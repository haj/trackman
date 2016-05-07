class ModifyLocationsForLogicalTrips < ActiveRecord::Migration
  def change
    rename_column :locations, :step, :ignite_step
    add_column :locations, :trip_step, :integer
  end
end
