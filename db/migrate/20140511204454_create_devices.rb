class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :name
      t.string :emei
      t.float :cost_price

      t.timestamps
    end
  end
end
