class AddStepsCounterToCarStatistics < ActiveRecord::Migration
  def change
    add_column :car_statistics, :steps_counter, :integer
  end
end
