class FixNewColumnsForLocationTable < ActiveRecord::Migration
  def change
  	add_column :locations, :status, :string
  	remove_column :locations, :start_point
  	remove_column :locations, :stop_point
  end
end
