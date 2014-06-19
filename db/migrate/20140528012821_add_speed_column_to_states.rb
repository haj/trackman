class AddSpeedColumnToStates < ActiveRecord::Migration
  def change
    add_column :states, :speed, :float, :default => 0
  end
end
