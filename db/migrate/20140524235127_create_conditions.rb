class CreateConditions < ActiveRecord::Migration
  def change
    create_table :conditions do |t|
      t.string :name
      t.string :method_name
      t.string :conjunction

      t.timestamps
    end
  end
end
