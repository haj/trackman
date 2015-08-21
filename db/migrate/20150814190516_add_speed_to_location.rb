class AddSpeedToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :speed, :string
  end
end
