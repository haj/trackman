class AddDateAndTimeToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :time, :datetime
  end
end
