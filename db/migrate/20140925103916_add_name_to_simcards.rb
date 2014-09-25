class AddNameToSimcards < ActiveRecord::Migration
  def change
    add_column :simcards, :name, :string
  end
end
