class AddColumnsToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :device_model_id, :integer
    add_column :devices, :device_type_id, :integer
    add_column :devices, :car_id, :integer
  end
end
