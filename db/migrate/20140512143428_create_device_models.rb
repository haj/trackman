class CreateDeviceModels < ActiveRecord::Migration
  def change
    create_table :device_models do |t|
      t.string :name
      t.integer :device_manufacturer_id
      t.string :protocol

      t.timestamps
    end
  end
end
