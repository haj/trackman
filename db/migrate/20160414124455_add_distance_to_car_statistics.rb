class AddDistanceToCarStatistics < ActiveRecord::Migration
  def change
    add_column :car_statistics, :tdistance, :float
  end
end
