class CreateParameters < ActiveRecord::Migration
  def change
    create_table :parameters do |t|
      t.string :name
      t.string :type
      t.integer :rule_id

      t.timestamps
    end
  end
end
