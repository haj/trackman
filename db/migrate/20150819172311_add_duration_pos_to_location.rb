class AddDurationPosToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :driving_duration, :string
    add_column :locations, :parking_duration, :string
  end
end
