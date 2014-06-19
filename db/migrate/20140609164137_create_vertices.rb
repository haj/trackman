class CreateVertices < ActiveRecord::Migration
  def change
    create_table :vertices do |t|
      t.float :latitude
      t.float :longitude
      t.integer :region_id

      t.timestamps
    end
  end
end
