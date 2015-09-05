class AddFieldsToLocationLongLat < ActiveRecord::Migration
  def change
    add_column :locations, :longitude, :float
    add_column :locations, :latitude, :float
  end
end
