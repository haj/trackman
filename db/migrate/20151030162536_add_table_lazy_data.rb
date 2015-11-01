class AddTableLazyData < ActiveRecord::Migration
  def change
    create_table :car_statistics do |t|
      t.references :car
      t.datetime :time
      t.integer :tparktime
      t.integer :tdrivtime
      t.float :maxspeed
      t.float :avgspeed
    end
  end
end
