class AddDriverIdToStates < ActiveRecord::Migration
  def change
    add_column :states, :driver_id, :integer
    add_column :states, :device_id, :integer
  end
end
