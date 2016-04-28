class AddWaitingForToCarStatistics < ActiveRecord::Migration
  def change
    add_column :car_statistics, :waiting_for_start, :boolean
  end
end
