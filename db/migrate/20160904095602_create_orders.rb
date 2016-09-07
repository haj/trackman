class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :customer_name
      t.float :latitude
      t.float :longitude
      t.string :package
      t.references :xml_destination, index: true
      t.string :aasm_state

      t.timestamps
    end
  end
end
