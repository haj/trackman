class AddDescriptionToAlarms < ActiveRecord::Migration
  def change
    add_column :alarms, :description, :string
  end
end
