class CreateCars < ActiveRecord::Migration
  def change
    create_table :cars do |t|
      t.float :mileage
      t.string :numberplate
      t.integer :car_model_id
      t.integer :car_type_id
      t.string :registration_no
      t.integer :year
      t.string :color
      t.integer :group_id

      t.timestamps
    end
  end
end
