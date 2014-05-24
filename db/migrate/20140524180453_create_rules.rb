class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.string :name

      t.timestamps
    end
  end
end
