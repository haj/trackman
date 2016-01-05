class AddAvgToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :avg, :float
  end
end
