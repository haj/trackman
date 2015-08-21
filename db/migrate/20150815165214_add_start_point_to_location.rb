class AddStartPointToLocation < ActiveRecord::Migration
  def change
    remove_column :locations, :start_point, :boolean, :default => false
  end
end
