class AddDeletedAtToSimcards < ActiveRecord::Migration
  def change
    add_column :simcards, :deleted_at, :datetime
    add_index :simcards, :deleted_at
  end
end
