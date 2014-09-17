class AddDeletedAtToRegions < ActiveRecord::Migration
  def change
    add_column :regions, :deleted_at, :datetime
    add_index :regions, :deleted_at
  end
end
