class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.string :address
      t.float :altitude
      t.float :course
      t.float :latitude
      t.float :longitude
      t.string :other
      t.float :power
      t.float :speed
      t.integer :device_id

      t.timestamps
    end
  end
end
