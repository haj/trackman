class AddLastIsToCarStatistics < ActiveRecord::Migration
  def change
    add_reference :car_statistics, :last_is, references: :locations
  end
end
