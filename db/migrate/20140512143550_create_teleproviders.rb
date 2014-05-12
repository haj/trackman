class CreateTeleproviders < ActiveRecord::Migration
  def change
    create_table :teleproviders do |t|
      t.string :name
      t.string :apn

      t.timestamps
    end
  end
end
