class CreateDestinationsDrivers < ActiveRecord::Migration
  def change
    create_table :destinations_drivers do |t|
      t.string :aasm_state
      t.references :user, index: true
      t.references :order, index: true

      t.timestamps
    end
  end
end
