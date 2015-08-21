class AddAnotherStartPointToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :start_point, :boolean, :default => false
  end
end
