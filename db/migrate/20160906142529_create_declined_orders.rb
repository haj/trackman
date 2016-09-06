class CreateDeclinedOrders < ActiveRecord::Migration
  def change
    create_table :declined_orders do |t|
      t.references :destinations_driver, index: true
      t.text :reason

      t.timestamps
    end
  end
end
