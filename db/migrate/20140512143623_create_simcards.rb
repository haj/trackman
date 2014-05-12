class CreateSimcards < ActiveRecord::Migration
  def change
    create_table :simcards do |t|
      t.string :telephone_number
      t.integer :teleprovider_id
      t.float :monthly_price
      t.integer :device_id

      t.timestamps
    end
  end
end
