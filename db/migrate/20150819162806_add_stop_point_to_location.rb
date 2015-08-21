class AddStopPointToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :stop_point, :boolean
  end
end
