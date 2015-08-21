class AddValidToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :valid_position, :boolean
  end
end
