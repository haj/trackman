class RemoveColumnWaitingForStartFromCarStatistics < ActiveRecord::Migration
  def change
    remove_column :car_statistics, :waiting_for_start
  end
end
