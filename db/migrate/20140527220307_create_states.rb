class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.boolean :data
      t.boolean :movement
      t.boolean :authorized_hours
      t.boolean :speed_limit
      t.boolean :long_hours
      t.boolean :long_pause
      t.integer :car_id

      t.timestamps
    end
  end
end
