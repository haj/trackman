class CreateAcceptedDestinations < ActiveRecord::Migration
  def change
    create_table :accepted_destinations do |t|
      t.references :destinations_driver, index: true
      t.integer :first_location_id, index: true
      t.integer :last_location_id, index: true
      t.string :aasm_state

      t.timestamps
    end
  end
end
