class RemoveColumnsFromStates < ActiveRecord::Migration
  def change
  	# remove few columns
  	remove_column :states, :speed_limit
  	remove_column :states, :long_hours
  	remove_column :states, :long_pause
  	remove_column :states, :authorized_hours

  	
  	# rename other columns
  	rename_column :states, :movement, :moving
  	rename_column :states, :data, :no_data
  	
  end
end
