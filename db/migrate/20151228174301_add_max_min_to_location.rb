class AddMaxMinToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :max, :float
    add_column :locations, :min, :float
  end
end
