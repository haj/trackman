class AddDefaultValuesToStatesColumns < ActiveRecord::Migration
  def change
  	change_column :states, :data, :boolean, :default => false
  	change_column :states, :movement, :boolean, :default => false
	change_column :states, :authorized_hours, :boolean, :default => false
	change_column :states, :speed_limit, :boolean, :default => false
	change_column :states, :long_hours, :boolean, :default => false
	change_column :states, :long_pause, :boolean, :default => false

  end
end
