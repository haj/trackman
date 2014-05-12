class CreateCarManufacturers < ActiveRecord::Migration
  def change
    create_table :car_manufacturers do |t|
      t.string :name

      t.timestamps
    end
  end
end
