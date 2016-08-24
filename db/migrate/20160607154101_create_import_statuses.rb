class CreateImportStatuses < ActiveRecord::Migration
  def change
    create_table :import_statuses do |t|
      t.integer :position_id

      t.timestamps
    end
  end
end
