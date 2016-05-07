class AddLastStartIdCarStatistics < ActiveRecord::Migration
  def change
    add_reference :car_statistics, :last_start, references: :locations
    add_reference :car_statistics, :last_stop, references: :locations
  end
end
