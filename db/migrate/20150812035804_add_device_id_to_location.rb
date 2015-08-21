class AddDeviceIdToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :device_id, :integer
  end
end
