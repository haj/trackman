class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.string :name
      t.string :method_name
      t.timestamps
    end
  end
end
