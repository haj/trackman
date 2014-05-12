class CreateDeviceManufacturers < ActiveRecord::Migration
  def change
    create_table :device_manufacturers do |t|
      t.string :name

      t.timestamps
    end
  end
end
